#!/usr/bin/env julia

using Sockets
using Dates
using JSON

# Simple HTTP Server implementation without external dependencies
function start_server(port=8080)
    server = listen(IPv4(0), port)
    println("Feedback server started at http://localhost:$port")
    
    while true
        conn = accept(server)
        @async begin
            try
                request = String(readuntil(conn, "

"))
                
                if occursin("POST /feedback", request)
                    # Get Content-Length
                    m = match(r"Content-Length: (\d+)", request)
                    if m !== nothing
                        len = parse(Int, m.captures[1])
                        body_raw = read(conn, len)
                        body = JSON.parse(String(body_raw))
                        
                        save_feedback(body)
                        
                        response = "HTTP/1.1 200 OK
Content-Type: application/json
Access-Control-Allow-Origin: *

{"status":"ok"}"
                        write(conn, response)
                    end
                elseif occursin("GET / ", request) || occursin("GET /index.html", request)
                    content = isfile("index.html") ? read("index.html", String) : "<h1>index.html not found. Run build.jl first.</h1>"
                    response = "HTTP/1.1 200 OK
Content-Type: text/html

$content"
                    write(conn, response)
                else
                    write(conn, "HTTP/1.1 404 Not Found

")
                end
            catch e
                println("Error: $e")
            finally
                close(conn)
            end
        end
    end
end

function save_feedback(data)
    topic = get(data, "topic", "Unknown")
    reader = get(data, "reader", "Anonymous")
    content = get(data, "content", "")
    date = Dates.format(now(), "yyyy-mm-dd HH:MM:SS")
    
    open("feedback.md", "a") do f
        write(f, "## Feedback on: $topic
")
        write(f, "- **Date**: $date
")
        write(f, "- **Reader**: $reader

")
        write(f, "$content

")
        write(f, "---

")
    end
    println("Feedback received for topic: $topic")
end

start_server()
