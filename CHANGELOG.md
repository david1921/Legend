# Changelog

## 0.5.8 (2014-06-26)

  * Bump Version ([Matt Schultz][mattschultz])

## 0.5.7 (2014-06-26)

  * Use Faraday Conductivity extended logging ([Matt Schultz][mattschultz])

## 0.5.6 (2014-06-25)

  * Log with Rails.logger ([Matt Schultz][mattschultz])

## 0.5.5 (2014-06-25)

  * Log Faraday requests ([Matt Schultz][mattschultz])

## 0.5.4 (2014-04-03)

  * Handle null Medication classes ([Matt Schultz][mattschultz])

## 0.5.3 (2014-03-27)

  * Improve boolean conversion ([Tyler Hunt][tylerhunt])

## 0.5.2 (2014-03-26)

  * Parse lab result values like "<16.4" ([Tyler Hunt][tylerhunt])

## 0.5.1 (2014-03-26)

  * Add display value to labs ([Tyler Hunt][tylerhunt])

## 0.5.0 (2014-03-20)

  * Rename Epic::Data to Epic::Models ([Tyler Hunt][tylerhunt])
  * Add result flag to labs ([Tyler Hunt][tylerhunt])

## 0.4.8 (2014-03-17)

  * Handle non-2xx responses ([Tyler Hunt][tylerhunt])
  * Add lab data simulator ([Tyler Hunt][tylerhunt])

## 0.4.7 (2014-03-12)

  * Add department ID parameter to demographics ([Tyler Hunt][tylerhunt])

## 0.4.6 (2014-03-11)

  * Add provider info to encounters ([Tyler Hunt][tylerhunt])

## 0.4.5 (2014-03-11)

  * Fix a typo in converting encounter referrals ([Mark Kendall][markkendall])

## 0.4.4 (2014-03-11)

  * Update to latest problem list diagnosis format ([Tyler Hunt][tylerhunt])

## 0.4.3 (2014-03-11)

  * Add order data simulator ([Tyler Hunt][tylerhunt])

## 0.4.2 (2014-03-07)

  * Return referral diagnoses with encounters ([Tyler Hunt][tylerhunt])
  * Add encounter data simulator ([Tyler Hunt][tylerhunt])
  * Add problem list data simulator ([Tyler Hunt][tylerhunt])
  * Add demographics data simulator ([Tyler Hunt][tylerhunt])

## 0.4.1 (2014-03-06)

  * Add user ID parameter to demographics endpoint ([Tyler Hunt][tylerhunt])
  * Add patient authentication endpoint ([Tyler Hunt][tylerhunt])

## 0.4.0 (2014-03-06)

  * Switch to all labs endpoint for lab results ([Tyler Hunt][tylerhunt])
  * Add encounters endpoint ([Tyler Hunt][tylerhunt])
  * Add orders endpoint ([Tyler Hunt][tylerhunt])

## 0.3.0 (2014-02-27)

  * Convert to use the Epic JSON API ([Tyler Hunt][tylerhunt])

## 0.2.4 (2014-02-26)

  * Skip coercion of Date objects ([Tyler Hunt][tylerhunt])
  * Add problem list diagnosis endpoint ([Tyler Hunt][tylerhunt])

## 0.2.3 (2014-02-26)

  * Ignore untrusted SSL cert errors, for now ([Mark Kendall][markkendall])

## 0.2.2 (2014-02-20)

  * Remove dependency on environment variables ([Tyler Hunt][tylerhunt])

## 0.2.1 (2014-02-19)

  * Get Epic URL from ENV ([Matt Schultz][mattschultz])

## 0.2.0 (2014-02-12)

  * Remove Faraday Middleware dependency ([Tyler Hunt][tylerhunt])

## 0.1.0 (2014-02-04)

  * Bump version to disambiguate from public gem ([Mark Kendall][markkendall])

## 0.0.4 (2014-01-25)

  * Use Ox for XML parsing to fix xmlns parsing ([Matt Schultz][mattschultz])

## 0.0.3 (2014-01-24)

  * Fix with date range parameter handling ([Matt Schultz][mattschultz])
  * Get Maestro configuration from ENV ([Matt Schultz][mattschultz])
  * Add HTTP Basic authentication ([Matt Schultz][mattschultz])
  * Add methods for additional API endpoints ([Matt Schultz][mattschultz])
  * Fix parsing of data parameters ([Matt Schultz][mattschultz])

## 0.0.2 (2014-01-24)

## 0.0.1 (2014-01-09)

  * Initial release ([Tyler Hunt][tylerhunt])

[markkendall]: https://github.com/markkendall
[mattschultz]: https://github.com/mattschultz
[tylerhunt]: https://github.com/tylerhunt
