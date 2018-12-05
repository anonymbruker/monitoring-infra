# Infra for monitoring

## What to change

- You need to go into variables.tf and change the variables to your own
- Look at the credentials_sample.yaml and replace with your own secrets
    - Generate deploy keys (ssh) and put the private part in the credentials file
    - Put the public key in your own respective repos
        - Note that infra repo needs write access!
    - You can find your heroku api key and email easily in 'manage account'
    - You can find statuscake api key and *username* easily in user details
    - github_token is you personal access token

## Command templates
#### my  command
```
fly -t pgr301 sp -p anonym-exam -c concourse/pipeline.yml -l credentials.yaml
```
#### fly command 
```
fly -t ≤target> sp -p pipeline_name -c concourse/pipeline.yml -l credentials.yaml
```