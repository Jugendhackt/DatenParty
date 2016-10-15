from wsgiref.simple_server import make_server

def application(environ, start_response):
    status = '200 OK'
    output = environ["PATH_INFO"]

    response_headers = [('Content-type', 'text/plain'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]

httpd = make_server('', 8000, application)
print "Serving HTTP on port 8000..."

# Respond to requests until process is killed
httpd.serve_forever()