---
title: "Superfantastic Password Management With Supergenpass"
date: 2010-07-14T10:40:27+02:00
draft: false
tags: [passwords]
categories: [programming]
---

![password on a wall](cover.jpg)

Nowadays, there are a million websites out there which force you to create an account. During this step you are required to provide a username and a password. If this process gets repeated more often, the need of a proper password management increases. The currently most used password management is the simple "use one for all" method. I hope we alle agree that is the worst of all methods. The best available method however (generating long arbitrary passwords and memorizing them) is not that practicable. So you need to find a system between those two extremes. A few months back, I chose a password managing system with the help of [SuperGenPass](https://www.supergenpass.com) and stuck since then.

## the system

[SuperGenPass](http://www.supergenpass.com) generally is a hashing algorithm which takes two inputs and then generates a password out of it. These two inputs are: your master password and the current web-site domain you are on. For example let's just use "grepthepipe" as the master password. Your generated password for [twitter.com](https://twitter.com) would then be "oaFhfaeK3K" (you can try it out on [https://supergenpass.com/mobile/](https://supergenpass.com/mobile/)). The provided bookmarklet simplifies the process of logging in. You simply enter your login and your master password (in the existing password field), hit the bookmarklet and the password is generated. You can change all your passwords on existing accounts to a SuperGenPass generated one and you'll end up with different password for every account. The upside to this is: You just have to remember one password for all your accounts and they are still different from each other. Yet, this system is not perfect. After converting almost 50 accounts to the SuperGenPass system I discovered some flaws.

## the flaws

### 1. same login on multiple domains

Most of the big shopping sites offer to login with the same account for multiple countries (amazon.com/de, ebay.com/de). With this system you will get different passwords for the different country specific sites.

### 2. different logins on same domain

For all the twitter fanatics that have so much to say, that one [twitter](https://twitter.com) account is obviously not enough (like me): no matter how hard you try this system will only produce one password on [tiwtter.com](https://twitter.com) (given one master password as input). This is especially critical when you share some of your accounts with a friend (you don't want to grant them access to your personal twitter account, do you?).

### 3. logins not related to a website

Although almost everything is the web nowadays, there a still some legacy system left that are not related to a domain in any way. For example your system login, your firefox master password, your favorite database etc... Those systems won't let you login using the SuperGenPass system.

## the workarounds

Although SuperGenPass [claims](http://supergenpass.com/faq/#Security) that the bookmarklet will work no matter what happens to the web-site, the first thing I did after switching to this system was installing a password manager (in my case: [1Password](http://agilewebsolutions.com/products/1Password)). This gives you additional security in case of a password loss (I don't want to got over all the web-sites and use the "forgot your passwort?" feature). For logging in I mainly use the bookmarklet (it even works on my iPhone or iPad). However there are same cases I cannot use the bookmarklet: For example: logging in in the iTunes Store or JavaScript bloated web sites. Thats where 1Password comes in handy. Unfortunately I could not get around learning my iTunes password by heart, as the login window on my iPhone does doesn't let me paste anything.

For the same login on multiple domains, I just log into [amazon.de](http://amazon.de) and then move on to [amazon.com](http://amazon.com) if I like to.

The different login names on the same side can be addressed in this way: not just only use your master password, but set your username as a prefix. In the example from the beginning you would the use "leifg_grepthepipe" instead of just "grepthepipe" as my master password and then get "f274w9i4sE" as my password for [twitter.com](http://twitter.com).

And for the third flaw you just have no other choice than not to use SuperGenPass (at least not for logging in). Use your master password or remember a second password for your system login.

## conclusion

I really like the idea of having a different password on every community I joined in the last few years. However this system is not safe at all if someone finds out your master password (and knows you're using SuperGenPass). So choose it carefully. Mmy way of choosing a password is just learning an [arbitrary generated phrase](http://www.pctools.com/guides/password/) by heart.

picture by [Bruce Guenter](http://www.flickr.com/photos/10154402@N03/4263984940/)/[CC BY-NC-SA 2.0](http://creativecommons.org/licenses/by-nc-sa/2.0/deed.en)
