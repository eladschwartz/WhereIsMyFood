# WhereIsMyFood - Orders Management/Tracking System

<h1 align="center">
  <img src="http://whereismyfood.biz/img/whereismyfood-logo.png"  width="200">
</h1>

**WhereIsMyFood** is an ordering system for resturants written in Swift and PHP Codeigniter (Using Stripe and Sinch)

<h1 align="center">
  <img src="http://whereismyfood.biz/img/app.png"  width="300" />
  <img src="http://whereismyfood.biz/img/web.png"   width="400" />
</h1>

Features
--------
**Resturant**
* Create a menu using the admin panel
* Assign a driver to an order
* Track the driver's location

**Customers**
* Make an order
* Track the order(track driver location)
 
 **Drivers**
* Get an order assignment from the resturant
 

Table of Contents
-----------------

[**Prerequisites**](#prerequisites)

[**Installation**](#installation)

[**Usage**](#usage)

[**Features**](#detailed-features)

[**Todo**](#todo)

[**License**](#license)

<br />

<a name="prerequisites"></a>

Prerequisites
------------

* Xcode 8
* Stripe Account
* Sinch Account(SMS verfcaiton)
* PHP > 5.6


Installation
------------

* You need to have a [Stripe](https://stripe.com) account for testing the order feature.

* You also need a [Sinch](https://www.sinch.com) account if you are going to use this in production.

* You can use this phone number to skip the SMS verification: +1 23456789 

* Please import the file "whereismyfood.sql" to your DB.

**Xcode** <br>
Go to Manager folder --> Constants.swift and change:

* BASE_URL
* STRIPE_KEY
* SINCH_KEY

To your own setup.

**PHP** <br>
Go to appliction folder --> cofnig.php and change:

* $config['base_url']

Go to appliction folder --> database.php and change:

* hostname
* username
* password
* database

To your own setup.


## Usage
This project is still under development but the major features are working.

You can download the guide for the Admin Panel from [Here](https://whereismyfood.biz/docs/amdin_guide.pdf)

You can download the guide for the Apps  from [Here](https://whereismyfood.biz/docs/amdin_guide.pdf)

Todo
----
**Server**
* Create a new order using admin panel(right now only customer can make a new order using the app)
* Add refund options (Full or Partial)
* Edit/Remove an item from order(= partial refund)

**Client**
* Fix some bugs
* Add payment with PayPal
* Add Order history
* Add Favorites




Testing
----

I tested the app on iPod, iPad(9.7) and iPhone 6s plus and it's working fine.

I didn't test payment with real credit card, only stripe test cards, but i'll do it when I add Paypal


Credits
----
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [CountryPicker](https://github.com/Keyflow/CountryPicker-iOS-Swift)
* [SkyFloatingLabelTextField](https://github.com/Skyscanner/SkyFloatingLabelTextField)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [LGSideMenuController](https://github.com/Friend-LGA/LGSideMenuController)

**Design**

* [Flat Icon](https://www.flaticon.com/)
* [Freepik](http://www.freepik.com/)
* [Freepik](http://www.freepik.com/)
* [Icons8](https://icons8.com/)
* 	The Desgin is Based on a template that I bought  from:  [Graphicriver](https://graphicriver.net/item/mosher-restaurant-mobile-app-ui-kit/17807658?_ga=2.135878321.1295015634.1502460424-1570167637.1483370751) - see license for this template:  [license](https://graphicriver.net/licenses/faq#license-freely-accessible-a)
    

License
-------
MIT License

Copyright (c) [2017] [Elad Schwartz]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
