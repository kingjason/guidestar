# Guidestar

Ruby wrapper around the [Guidestar](http://guidestar.org) API.

## Install

  gem install guidestar-ruby

## Usage

First initialize the client with your credentials:

```ruby
  Guidestar::Client.set_credentials(<user>, <password>)
```

Now you can perform searches by keyword:

```ruby
  Guidestar::Client.search(:keyword => "poverty")
```

Search by organization name:

```ruby
  Guidestar::Client.search(:name=> "Red Cross")
```

Search by EIN:

```ruby
  Guidestar::Client.search(:ein => "52-5367724")
```

Search by city and state:

```ruby
  Guidestar::Client.search(:city => "San Francisco", :state => "CA")
```

Search by zip:

```ruby
  Guidestar::Client.search(:zip => "23556")
```

Search by NTEE code:

```ruby
  Guidestar::Client.search(:ntee_code => "A25")
```

Additional options (and their respective defaults):

```ruby
  {
    :page_size => 25, # number of results per page
    :offset => 0,     # page number
    :categories => ["C1_Arts_Culture_and_Humanities"],
    :sub_categories => ["C1_Performing_Arts"]
  }
```

### Organization Categories & Sub-Categories

Categories (defaults to "C1_Arts_Culture_and_Humanities"):

* "C1_Arts_Culture_and_Humanities"
* "C2_Education_and_Research"
* "C3_Environment_and_Animals"
* "C4_Health"
* "C5_Human_Services"
* "C6_International"
* "C7_Public_Societal_Benefit"
* "C8_Religion"
* "C9_Unknown"

Sub-Categories (defaults to "C4_Performing_Arts"):

* "C1_Humanities_and_Historical_Societies"
* "C1_Media"
* "C1_Museums"
* "C1_Performing_Arts"
* "C1_Service_and_Other"
* "C2_College_and_University"
* "C2_Elementary_and_Secondary"
* "C2_Libraries"
* "C2_Research_Institutes"
* "C2_Service_and_Other"
* "C2_Vocational_Technical_and_Adult"
* "C3_Animal_Protection_Welfare_and_Services"
* "C3_Beautification_and_Horticulture"
* "C3_Conservation_and_Environmental_Education"
* "C3_Health_Care_Facilities_and_Programs"
* "C3_Pollution"
* "C3_Service_and_Other"
* "C3_Zoos_and_Veterinary_Services"
* "C4_Addiction_and_Substance_Abuse"
* "C4_Diseases_and_Disease_Research"
* "C4_Health_Care_Facilities_and_Programs"
* "C4_Medical_Disciplines_and_Specialty_Research"
* "C4_Mental_Health_and_Crisis_Services"
* "C5_Agriculture_Food_and_Nutrition"
* "C5_Crime_and_Legal_Related"
* "C5_Employment_and_Occupations"
* "C5_General_Human_Services"
* "C5_Housing"
* "C5_Public_Safety_Disaster_Preparedness_and_Relief"
* "C5_Recreation_and_Sports"
* "C5_Youth_Development"
* "C6_International_Development_and_Relief_Services"
* "C6_International_Human_Rights"
* "C6_International_Peace_and_Security"
* "C6_Promotion_of_International_Understanding"
* "C6_Service_and_Other"
* "C7_Civil_Rights_and_Liberties"
* "C7_Community_Improvement"
* "C7_Mutual_or_Membership_Benefit_Organizations"
* "C7_Philanthropy_Voluntarism_and_Public_Benefit"
* "C7_Service_and_Other"
* "C7_Voter_Education_and_Registration"
* "C8_Buddhist"
* "C8_Christian"
* "C8_Hindu"
* "C8_Islamic"
* "C8_Jewish"
* "C8_Religious_Media"
* "C8_Service_and_Other"
* "C9_Unknown"

## Dependencies

* [nokogiri](http://github.com/tenderlove/nokogiri)
* [rest-client](http://github.com/archiloque/rest-client)

## Copyright

Copyright (c) 2012 Gemini SBS. See LICENSE for details.

## Authors

* [Mauricio Gomes](http://github.com/mgomes)
