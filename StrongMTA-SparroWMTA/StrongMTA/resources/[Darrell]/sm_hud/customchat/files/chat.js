const keyCodes = {
	enter: 13,
	tab: 9
};

const state = {
	scroll: false,
	canScrollToBottom: true,
	lastRegisteredDelayCallback: null,
	chatType: 'default'
};

let elements;

function setBackgroundAlpha(alpha) {
	elements.chat.style.backgroundColor = "rgba(0, 0, 0, " + alpha + ")";
	elements.oocchat.style.backgroundColor = "rgba(0, 0, 0, " + alpha + ")";
}

function setFontBackgroundAlpha(alpha) {
	document.body.style.textShadow = "1px 1px rgba(0, 0, 0, " + alpha + ")";
}

function setFontSize(size) {
	document.body.style.fontSize = size + "%";
}

function resizeIC(width, height, fontSize) {
	elements.chat.style.width = width + "px";
	elements.chat.style.height = height + "px";

	if (fontSize) {
		document.body.style.fontSize = fontSize + "% !important";
	} else {
		scrollToBottom(true);
	}
}

function resizeOOC(width, height) {
	elements.oocchat.style.width = width + "px";
	elements.oocchat.style.height = height + "px";

	elements.oocchatMessages.scrollTo({
		top: elements.oocchatMessages.scrollHeight,
		behavior: "smooth"
	});
}

function show(bool) {
	if (!bool) {
		elements.chat.classList.add("hidden");
		elements.oocchat.classList.add("hidden");
		return;
	}

	elements.chat.classList.remove("hidden");
	elements.oocchat.classList.remove("hidden");

	if (bool) {
		elements.input.addEventListener("keydown", preventPressTab);
		elements.oocinput.addEventListener("keydown", preventPressTab);
	} else {
		elements.input.removeEventListener("keydown", preventPressTab);
		elements.oocinput.removeEventListener("keydown", preventPressTab);
	}

	scrollToBottom();
}

function showInput(title, typ) {
	if (typ == "ooc") {
		state.chatType = "ooc";

		elements.oocinput.value = "";
		elements.oocinputLabel.innerText = title;
		elements.oocinputBlock.classList.remove("hidden");
		elements.oocinput.style.paddingLeft = `${elements.oocinputLabel.offsetWidth + 5}px`;

		setTimeout(() => {
			elements.oocinput.focus();
			document.addEventListener("keydown", onKeydownEnterButton);
			document.addEventListener("click", onBlur);
		}, 0);
	} else {
		state.chatType = "default";

		elements.input.value = "";
		elements.inputLabel.innerText = title;
		elements.inputBlock.classList.remove("hidden");
		elements.input.style.paddingLeft = `${elements.inputLabel.offsetWidth + 5}px`;

		setTimeout(() => {
			elements.input.focus();
			document.addEventListener("keydown", onKeydownEnterButton);
			document.addEventListener("click", onBlur);
		}, 0);
	}
}

function hideInput() {
	elements.inputBlock.classList.add("hidden");
	elements.input.blur();

	elements.oocinputBlock.classList.add("hidden");
	elements.oocinput.blur();

	document.removeEventListener("keydown", onKeydownEnterButton);
	document.removeEventListener("click", onBlur);
}

function addMessage(message) {
	const messageElement = document.createElement("div");
	messageElement.classList.add("chat__message");

	const messageFragment = document.createDocumentFragment();
	const partElement = document.createElement("span");

	partElement.innerHTML = message;
	messageFragment.appendChild(partElement);

	messageElement.append(messageFragment);
	elements.chatMessagesContainer.append(messageElement);

	var messages = document.getElementsByClassName('chat__message');

	if (messages.length > 55) {
		messages[0].parentElement.removeChild(messages[0]);
	}

	scrollToBottom();
}

function addMessageOOC(message) {
	const messageElement = document.createElement("div");
	messageElement.classList.add("oocchat__message");

	const messageFragment = document.createDocumentFragment();
	const partElement = document.createElement("span");

	partElement.innerHTML = message;
	messageFragment.appendChild(partElement);

	messageElement.append(messageFragment);
	elements.oocchatMessagesContainer.append(messageElement);

	var messages = document.getElementsByClassName('oocchat__message');

	if (messages.length > 10) {
		messages[0].parentElement.removeChild(messages[0]);
	}

	elements.oocchatMessages.scrollTo({
		top: elements.oocchatMessages.scrollHeight,
		behavior: "smooth"
	});
}

function scrollToBottom(force = false) {
	if (force) {
		state.canScrollToBottom = true;
		state.lastRegisteredDelayCallback = null;
	}

	if (!state.canScrollToBottom) return;

	elements.chatMessages.scrollTo({
		top: elements.chatMessages.scrollHeight,
		behavior: "smooth"
	});
}

function preventPressTab(e) {
	if (e.keyCode == keyCodes.tab) e.preventDefault();
}

function scroll(definition) {
	if (!state.scroll) return;
	const value = definition == "scrollup" ? -10 : 10;
	elements.chatMessages.scrollBy({ top: value });
	setTimeout(scroll, 25, definition);
}

function clearIC() {
	elements.chatMessagesContainer.innerHTML = "";
}

function clearOOC() {
	elements.oocchatMessagesContainer.innerHTML = "";
}

function registerDelayCallback() {
	state.canScrollToBottom = false;

	let callback = function() {
		if (!state.lastRegisteredDelayCallback) return;

		if (callback.uniqueId !== state.lastRegisteredDelayCallback.uniqueId) {
			return;
		}

		state.canScrollToBottom = true;
		scrollToBottom();
		state.lastRegisteredDelayCallback = null;
	};
	callback.uniqueId = Date.now();

	state.lastRegisteredDelayCallback = callback;
	setTimeout(callback, 5000);
}

function onKeydownEnterButton(ev) {
	if (ev.keyCode !== keyCodes.enter) return;

	if (state.chatType == "default") {
		mta.triggerEvent("onCustomChatEnterButton", elements.input.value);

		scrollToBottom(true);
	} else {
		mta.triggerEvent("onCustomChatEnterButton", elements.oocinput.value);

		elements.oocchatMessages.scrollTo({
			top: elements.oocchatMessages.scrollHeight,
			behavior: "smooth"
		});
	}
}

function startScroll(definition) {
	state.scroll = true;
	scroll(definition);
}

function onBlur() {
	if (state.chatType == "default") {
		elements.input.focus();
	} else {
		elements.oocinput.focus();
	}
}

function stopScroll() {
	state.scroll = false;

	if (elements.chatMessages.scrollHeight - elements.chatMessages.scrollTop - parseInt(getComputedStyle(elements.chatMessages).height) <= 1) {
		state.canScrollToBottom = true;
		state.lastRegisteredDelayCallback = null;
		return;
	}

	registerDelayCallback();
}

function onDOMContentLoaded() {
	elements = {
		chat: document.querySelector(".chat"),
		inputBlock: document.querySelector(".chat__input-block"),
		inputLabel: document.querySelector(".chat__input-label"),
		input: document.querySelector(".chat__input"),
		chatMessages: document.querySelector(".chat__messages"),
		chatMessagesContainer: document.querySelector(".chat__messages-container"),

		oocchat: document.querySelector(".ooc"),
		oocinputBlock: document.querySelector(".ooc__input-block"),
		oocinputLabel: document.querySelector(".ooc__input-label"),
		oocinput: document.querySelector(".ooc__input"),
		oocchatMessages: document.querySelector(".ooc__messages"),
		oocchatMessagesContainer: document.querySelector(".ooc__messages-container")
	};

	mta.triggerEvent("onCustomChatLoaded");
}

document.addEventListener("DOMContentLoaded", onDOMContentLoaded);