# Simple hello world flask app to test

PS C:\Code\SimpleFlask> docker run -p 8077:8080 simpleflask
 * Serving Flask app "main" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
172.17.0.1 - - [05/Aug/2018 20:17:48] "GET / HTTP/1.1" 200 -


Then you should be able to curl on port 8077 and get a "hello world" answer

# build
PS C:\Code\SimpleFlask> docker build -t simpleflask .
PS C:\Code\SimpleFlask> docker tag 0fb359f3cfbe charly37/simpleflask:1
PS C:\Code\SimpleFlask> docker push charly37/simpleflask:1