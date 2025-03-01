
## About

A week ago, as I was doing a presentation for my friends & colleagues about #kamal deployment tool, I mentioned that it's not only #rails or #sinatra apps that you can deploy but pretty much anything that you can Docker-contenerize.To illustrate that, and, admittedly, for the fun of it, I tried today to deploy JupyterLab with Ruby interpreter (another thing I mentioned in a presentation) with Kamal. Works like charm! Within minutes you can set yourself a cost-effective HTTPS-protected python/ruby sandbox for little scripts and fun stuff.

by default it's protected with a token you can extract logs by running `kamal app logs` (token will be somewhere in 20 first lines after server starts).

There are tons of configurable options for the JupyterLab base image which you can explore here: https://github.com/jupyter/docker-stacks.

## Kamal and SSL
Kamal provides very convenient, automatic SSL configuration for one-node deployments with Lets Encrypt.
<img width="1138" alt="Screenshot 2025-03-01 at 16 12 31" src="https://github.com/user-attachments/assets/5c933c8e-674d-4856-ae03-1fa6eaff44f8" />

## How to set it up!

1. add dns entry to your domain
2. get yourself an IP of your VPS with free ports 443 and 80
3. get yourself a Docker image repo for this project (eg AWS ECR private repo)
4. Replace IP and host in `config/deploy.yml`
5. configure SSH connection details (user/cert) in `ssh` key of the `deploy.yml`
6. Once that's done, do:

```bash
rvm install 3.4.1
rvm use 3.4.1
gem install kamal
kamal setup # for 1st time only; later `kamal deploy`
```

enjoy!
