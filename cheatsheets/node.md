
## Development API testing

While developing on a api you love Livereload. It restart you server after a change.

    sudo npm install supervisor -g
    supervisor <app-server>.js
    
    # If you need to watch certain files
    supervisor -e 'js|ejs|node|coffee' app.js

Or use `nodemon`

## Authentication testing
Talk to the api with curl:

    curl http://localhost:3001/post/all -H "Authorization: Bearer ...fFGvDbtCOdjs..."
