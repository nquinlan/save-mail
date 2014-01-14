# Save Mail - _Email Uploaded to Amazon S3_
This app uploads emails it receives to S3. Out of the box, it works well to create "View On Web" links within personalized emails.

## Requirements
- Parse Webhook - _This app relies on the [SendGrid Parse Webhook](http://sendgrid.com/docs/API_Reference/Webhooks/parse.html), however, it could be [configured to use another webhook](#other-services)._
- AWS Account
- Hosting Provider - _Heroku is ready to go, however, you can upload to any provider that supports webhooks._

## <a name="quick-start"></a> Quick Start
To start using this app you must do two things: deploy the app and setup your parse webhook.

1. Clone the repository to your computer. <br/>
`git clone https://github.com/nquinlan/save-mail.git save-mail`
2. Move into the repository. <br/>
`cd save-mail`
3. Initialize Heroku. <br/>
`heroku init`
4. Provide Heroku with your app's credentials. <br/>
`heroku config:set S3_ACCESS_KEY_ID=your-s3-access-key S3_SECRET_ACCESS_KEY=your-s3-secret-key S3_BUCKET=your-s3-bucket`
5. Deploy to Heroku. <br/>
`git push heroku master`
6. [Setup a webhook](http://sendgrid.com/developer/reply) to post to your new Heroku app.

This will start saving all mail received by the domain the Parse Webhook is setup on. 

## URLs
By default Save Mail saves each email with a [Universally Unique Identifier](http://en.wikipedia.org/wiki/Universally_unique_identifier), however, you may specify what you wish the file name to be instead.

You may specify the URL (or at least the file name) you intend for the stored email to have by specifying an `X-Save-Mail-ID` in the headers of your message (as seen below). This ID will be the file name for the email when uploaded to S3.

```
X-Save-Mail-ID: super-cool-message
```
The message will be stored on S3 at `http://s3.amazonaws.com/your-bucket-name/super-cool-message.html`

_**All files stored by Save Mail have the extension `.html`**_

## Templates
Save Mail comes with two templates, found in [_templates](https://github.com/nquinlan/save-mail/tree/master/_templates), however you may modify and change these how you wish. To have an email be stored with a certain template, simply send your email with an `X-Save-Mail-Template` header (as seen below). This will save the message with the specified template

```
X-Save-Mail-Template: preserve-headers
```
The message will be saved with the template [`preserve-headers.html.erb`](https://github.com/nquinlan/save-mail/blob/master/_templates/preserve-headers.html.erb).

## <a name="other-services"></a> Other Services
Although this code is meant for the [SendGrid Parse Webhook](http://sendgrid.com/docs/API_Reference/Webhooks/parse.html), it should also work with a few other services, with limited changes: _(Warning: These have not been tested)_

- **[Mandrill](http://help.mandrill.com/entries/22092308-What-is-the-format-of-inbound-email-webhooks-)** should work without modification
- **[zapier](https://zapier.com/zapbook/email/webhook/)** might work, but they sure do hide their documentation. Make sure `html` and `headers` parameters are POSTed as a form.
- **[cloudmailin](http://docs.cloudmailin.com/http_post_formats/original/)** change `params[:headers]` to `params[:message]` and use their original HTTP POST format.
- **[mailgun](http://documentation.mailgun.com/user_manual.html#routes)** change `Mail.new(params[:headers])` to simply `params[:message-headers]`

## License
This code is licensed MIT. Please, build things with it.

