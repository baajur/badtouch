descr = "http cookies"

function verify(user, password)
    session = http_mksession()

    -- set cookies
    req = http_request(session, 'GET', 'https://httpbin.org/cookies/set', {
        query={
            cookie='success',
            foo='bar'
        }
    })
    resp = http_send(req)
    if last_err() then return end

    -- print(resp)
    -- print(resp["headers"]["set-cookie"])

    -- check cookies have been setup
    -- TODO: removing the {} causes a segfault
    req = http_request(session, 'GET', 'https://httpbin.org/cookies', {})
    resp = http_send(req)
    if last_err() then return end
    if resp['status'] ~= 200 then return 'invalid status code: ' .. resp['status'] end

    json = json_decode(resp['text'])
    if last_err() then return end
    -- print(json)

    return json['cookies']['foo'] == 'bar'
end
