connection = exports.sm_database:getConnection()
dbQuery(
        function (qh)
            local result = dbPoll(qh, 0, true)

            for k, v in ipairs(result[1][1]) do
                table.insert(accounts, v)
            end

            for k, v in ipairs(result[2][1]) do
                table.insert(wantedcars, v)
            end

            for k, v in ipairs(result[3][1]) do
                table.insert(wantedpeople, v)
            end

            for k, v in ipairs(result[4][1]) do
                table.insert(punishedpeople, v)
            end
        end,
        connection, [[
			SELECT * FROM mdc_accounts;
			SELECT * FROM mdc_wantedcars ORDER BY id DESC;
			SELECT * FROM mdc_wantedpeople ORDER BY id DESC;
			SELECT * FROM mdc_punishedpeople ORDER BY id DESC;
		)