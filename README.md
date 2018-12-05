# Infra for monitoring

## What to change

- You need to go into monitoring-infra/terraform/variables.tf and change the variables to your own
- Look at the monitoring-infra/credentials_sample.yaml and replace with your own secrets
    - Generate deploy keys (ssh) and put the private part in the credentials file
    - Put the public key in your own respective repos
        - Note that infra repo needs write access!
    - You can find your heroku api key and email easily in 'manage account'
    - You can find statuscake api key and *username* easily in user details
    - github_token is you personal access token

## Command templates

#### [heroku](https://dashboard.heroku.com/) commands
```
heroku login
```
#### [concourse](https://concourse-ci.org/) commands
```
docker-compose up -d
docker-compose down
```
#### [fly](https://concourse-ci.org/fly.html) commands
```
fly -t ≤target> login
fly -t ≤target> sp -p pipeline_name -c concourse/pipeline.yml -l credentials.yaml
```
#### [terraform](https://www.terraform.io/) commands
```
terraform init
terraform apply
```
##### my pipeline command
```
fly -t pgr301 sp -p anonym-exam -c concourse/pipeline.yml -l credentials.yaml
```


## Problems along the way

I had a huge issue which took up most of my time during the exam period. There didn't really seem to be a fix that would work for me on this.

#### Problem

![error_message][error]

After replacing keys in credentials.yaml, and changing all needed files(as can be seen in code), I would still get this error.

I did the complete sequence of actions to do 5 times(setup of exam). This includes doing it on two different computers, with different users(both git, heroku and statuscake) in which I had to install all needed programs on my job-pc. This still would not work.

#### Detailed what I did

##### Setup
- Clone the infra repo and the app repo
- Starting with app repo
    - I changed the procfile from using $PORT to %PORT% as I am on windows
    - Added a .env file containing ```JDBC_DATABASE_URL=jdbc:h2:mem:test```
    - Created an SSH deploy key named "deploy_app" with blank passwords using
    ```ssh-keygen -t rsa -b 4096 -C "your_email@example.com"```
    - Added the deploy_app.pub under the repos deploy keys, with read/write access
    - (Later added the private part to credentials.yaml file in infra)
- Infra
    - Started by changing the variables.tf file to something of my liking
        - Also added two extra variables, "statuscake_username" and "heroku_email"
        - added these vars to statuscake.tf and provider_heroku.tf by writing eg. ${var.statuscake_username}
    - Edited pipeline.yml
        - Edited the repos to be ((app_repo_uri)) and ((infra_repo_uri))
            - These can now be accessed from credentials.yml respectively
        - As my root folders are monitoring-infra/app, there was no need for further change
        - I did try both using exam-infra/app as well as monitoring-infra/app
            - Where I obviously changed every name needed
            - Every path name in pipeline.yml, /concourse/java/task.yml
    - Created an SSH deploy key named "deploy_infra" with blank passwords using
    ```ssh-keygen -t rsa -b 4096 -C "your_email@example.com"```
    - Added the deploy_infra.pub under the repos deploy keys, with read/write access
    - Added the private deploy_infra to credentials.yaml with correct semantics
        - A space between pipe "|" and :
        - Double spaces indent on the left
        - Example shown in credentials_sample.yaml
    - Added my heroku email as well as my API key to credentials.yaml
        - Located under manage account
        - Heroku user is linked to github
    - Added statuscake API key and username as well
        - Located under user details
    - Created and added a [Personal Access Token](https://github.com/settings/tokens)
- I created respective .gitignore files which you can see in my repo, to not check in my secret keys

##### Running
I am logged in to my heroku account using *heroku login*

I run, in monitoring-infra/docker
```
docker-compose up -d
```
Now after this is up and running, I use git bash to run some more commands. Starting from the root folder /monitoring-infra I run
```
fly -t pgr301 login
# I am now logged into main

fly -t pgr301 sp -p anonym-exam -c concourse/pipeline.yml -l credentials.yaml
```
This will create my pipeline using the credentials.yaml file to fill in my secret keys.

- Go to http://localhost:8080
- Log in to main
- Click "infra" job
- Make sure the pipe is *running*
- Click the (+) sign at the top right

After this I wait until gets to the *apply* task, in which it fetches some stuff but at the end fails.

I get this error message

![error_message][error]

I googled this and tried to troubleshoot a lot. I was only able to find a single *slightly* similar case, in which the linux container was 247, rather than 348.
[Here](https://github.com/facebook/fbctf/issues/431) you can see the full github post.

There was a fix for that, which is in the post, however this did not work for me at all. I tried the chmod +x *filename*, to "fix" the file, but this did not work for me.
I also read something about pruning worker, but this was not something that I could do either.

I *was* however able to run ```terraform init``` then ```terraform apply``` in monitoring-infra/terraform manually, and it would create a pipeline in heroku and tests in statuscake. (I obviously deleted the pipeline and such when I tried again later as the max amount of heroku apps is 5 for me)

### Final words

I decided to the best out of my situation as I still know how to set it up, and have been able to do this during the course in our practice sessions.

I have tried in this readme file to explain in detail how, to do everything, and what to do, to show not only my competence in this subject, but my ability to debug/troubleshoot. You should be able to fork my repos as per usual, and it should work for you.

[error]: https://i.imgur.com/ggNYjZA.png "error_message"