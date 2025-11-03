function get_account(source, username)
    -- Get API URL from global server configuration
    local url = get("api_base_url") or "http://127.0.0.1:8000"
    local apiEndpoint = url .. '/userdata/' .. username
end