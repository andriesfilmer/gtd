## Install Node.js (14)

After system update, install Node.js 14 on Ubuntu 22.04 by first installing the required repository.

    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -

Once the repository is added, you can begin the installation of Node.js 14 on Ubuntu Linux:

    sudo apt-get install -y nodejs


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
