# webscraping
Webscraper website built with mechanize and sinatra and deployed on amazon web services


# Get running

To get running on local machine, follow these steps:

1. Download Ruby: Found [here](https://rubyinstaller.org/)

2. Clone and Download Repository

3. Run "gem install bundler"

4. Run "bundle install"

5. Run "bundle update"

6. Run "ruby app.rb"

# Understanding the Codebase

**.elasticbeanstalk** - used for deploying through amazon web service. Do not mess with.

**config/database.yml** - used for building database and user login

**csv/** - comma separated value sheets. this is where the scrapers will spit out their data.

**db** - database

**models** - login.rb is for the database. webscrapers.rb contains logic for scrapers and contains info for Products class

The Products class needs to be separated out into its own file within models/

**public/styles** - CSS styles

**views** - rendering the pages and showing data to users

**app.rb** - responsible for the routes, transmitting information and needs to be refactored later