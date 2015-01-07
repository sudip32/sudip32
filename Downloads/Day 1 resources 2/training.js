'use strict';
// Introduction to JavaScript

// different ways to including JavaScript in html file

// where to put JavaScript

/****************************************** Basics of JavaScript *********************************/

// comments in JavaScript

// variable declearation

// for looop, while loop for in loop
var i = 0;
for(; i < 10; i += 1) {	
	console.log(i);
}
while (true) {
	console.log('')
}
// if elseif else
if(condition) {

} else if (condition1) {

} else {

}

// object literals
var arr = new Array();
var arr1 = []
var firstName = new String("Madhu")
var firstName = "madhu";
var obj = {};

// some object methods (array, object etc.)
{}.toString()
"madhu".toUpperCase()
[].push()
[].pop()
[].shift()
[].unshift()
[].length

// function declearation (diff between function expression and declearation)
var sayHello = function(name) {
	var hello = "Hello ";
	return hello + name;
};
var k= 0;
for (; k < 10; k++) {

}

console.log(k);

k = 10

var sayHello = function sayHello() {

}

function sayHello() {

}

// returning from function
// creating class in JavaScript

function Person(first, last) {
	this.first = first;
	this.last = last || 'Shrestha';
}

Person.prototype.fullName = function() {
	return this.first + " " + this.last;
}

var madhu = new Person("madhu rakhal", "magar");
madhu.fullName();

function SuperPerson(first, last, power) {
	Person.call(this, first, last);
	this.power = power;
}
SuperPerson.prototype = new Person();
SuperPerson.prototype.constructor = SuperPerson;

// Event Handeling in JavaScript
var button = document.getElementById('sayHello');
button.addEventListener('click', function(event) {
	alert("Ouch you click me!");
});
// Some of the pitfalls in JavaScript (hoisting, global variables)

// Best practices in JavaScript ('use strict', local variable, equality)



/**************************************** jQuery Basics **************************************************/

// selector in jQuery
var button = $("#id");
var ps = $("p");
var clas = $(".myclass");

// Event Handeling in jQuery
button.on('click', clickHaneler);

// jQuery utility methods
$.each();
$.toArray();

// ajax using jQuery

// Debugging JavaScript


// sample example 
// - form validation
// - use of ajax
// - or intregate jquery plugin.

