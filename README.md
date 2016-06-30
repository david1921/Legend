


Interface to the Epic API.


## Installation

Add this line to your application's `Gemfile`:

``` ruby
gem 'legend', :git => 'https://github.com/SutterRDD/Legend.git'
```

And then execute:

    $ bundle


## Usage

Here’s an example showing the various calls the can be made to fetch various
aspects of a patient’s records.

``` ruby
patient = Legend::Patient.new(
  id: patient_id,
  username: encryped_username,
  password: encryped_password,
  type: 'EXTERNAL',
  url: EPIC_URL,
)

start_date = Date.new(2011, 10, 17)
end_date = Date.new(2013, 10, 17)

patient.data(start_date: start_date, end_date: end_date)
patient.demographics
patient.labs(start_date: start_date, end_date: end_date, min_values: 4)
patient.medication_orders(start_date: start_date, end_date: end_date)
patient.problem_list_diagnosis(start_date: start_date, end_date: end_date)
patient.providers(start_date: start_date, end_date: end_date)
patient.vitals(start_date: start_date, end_date: end_date, min_values: 4)
```

The `date` parameter passed to these calls may be either a `Range` of `Date`
objects or a single `Date` object.

As an alternative to passing the URL as an option to `Epic::Patient` you may
set an environment variable called `EPIC_URL`.


### Simulated API Responses

For testing purposes, simulated response objects may be generated using the
provided factories.

``` ruby
Legend::Simulators::Demographics.build # => #<Legend::Data::Demographics>
```

To use the simulators, you’ll need to add `factory_girl` and `faker` to your
`Gemfile`.


## Development

### Releasing a New Version

Before releasing, ensure the version has been bumped in `lib/legend/version.rb`
and that the `CHANGELOG.md` has been updated with the new version number and
release date. Commit these changes with a message like "Release 0.4.0.".

Once the gem is ready to be released, use the provided Rake task to handle the
release by issuing the following command from the project root:

``` sh
rake release
```

This will ensure there is no uncommitted code, build the gem, tag the release,
push the code and a release tag to the remote, and push the gem to Gemfury.


Interface to the Epic API


