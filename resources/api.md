## API Resourses



## Info about creating a API

* [Google - API Design Guide](https://cloud.google.com/apis/design/)

### RESTful api
* [Best Practices for Designing a Pragmatic RESTful API](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)
* [Promisses explained](https://www.promisejs.org/)
* [JavaScript Promises](http://www.html5rocks.com/en/tutorials/es6/promises/)

### NodeJs
* [Authentication with AngularJS and a Node.js REST api](http://www.kdelemme.com/2014/03/09/authentication-with-angularjs-and-a-node-js-rest-api/) |
[Demo]( http://projects.kdelemme.com/blog/app/#/)
* [How To Implement Password Reset In Node.js](http://sahatyalkabov.com/how-to-implement-password-reset-in-nodejs/) using Express, MongoDB, Passport and Nodemailer.
* [Creating a REST API using Node.js, Express, and MongoDB](http://coenraets.org/blog/2012/10/creating-a-rest-api-using-node-js-express-and-mongodb/)

### AngularJs
* [Promisses in Angular](http://busypeoples.github.io/post/promises-in-angular-js/) | [Fiddle example](http://jsfiddle.net/jsengel/8fzmqy4y/)
* [Elegant token-based API access with AngularJS](http://engineering.talis.com/articles/elegant-api-auth-angular-js/) written by chris clarke
* [AngularJS Token Authentication using ASP.NET Web API 2, Owin, and Identity](http://bitoftech.net/2014/06/09/angularjs-token-authentication-using-asp-net-web-api-2-owin-asp-net-identity/)
* [Rails Angular JWT example](https://github.com/Foxandxss/rails-angular-jwt-example)

### Rails

* [Using CORS with Rails](http://leopard.in.ua/2012/07/08/using-cors-with-rails/)

## OAuth providers

* [OpenID Connect is a simple yet powerful signin protocol](http://openid.net/developers/libraries/)
* [Mozilla Persona - A sign-in system for the web](https://www.mozilla.org/en-US/persona/) [Github](https://github.com/mozilla/persona)
* [The best way to integrate OAuth in Angular](http://go.oauth.io/angular/)
* [ The user management API](https://www.userapp.io/)


## Token based authentication

* [Token Based Authentication in Rails](http://blog.envylabs.com/post/75521798481/token-based-authentication-in-rails)
* [Example of Token-based authentication in AngularJS with Express](https://github.com/auth0/angular-token-auth)
* [Token-Based Authentication With AngularJS & NodeJS](http://code.tutsplus.com/tutorials/token-based-authentication-with-angularjs-nodejs--cms-22543)
* [Reissues accesstoken with endpoint](https://nudgestage.jawbone.com/up/developer/authentication)

## OpenID & OAuth
OpenID is used for logging in and creating accounts on external websites. I don’t want to fill out a registration form or memorize another password to post a comment on a blog post. OpenID allows me to bypass traditional registration and authenticate my identity with login credentials from another website that I’m already registered on, such as Google+ and Facebook. In short, authentication means one website telling another website, “He is who he says he is.”

OAuth goes a bit deeper and is used to grant third-party websites and apps permission to access information on another social network or website. Whenever you sign up for a messaging app, it may ask permission to retrieve your Facebook friends to help you connect with more people. This is often authorized through OAuth. OAuth typically requires authentication prior to authorization, so it’s frequently used in tandem with OpenID. One website tells the other, “He is who he says he is, and here’s the info you asked for.”

[Source: Facebook, Twitter, Google+, or LinkedIn … Which should you log in with?](https://www.comparitech.com/blog/vpn-privacy/facebook-twitter-google-or-linkedin-which-should-you-log-in-with/)

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