---
layout: post
title: "Grabbing Timestamp Data from Logs"
date: 2013-10-04
categories: Unix
preview: a quick helpmate for back-of-the-envelope performance metrics
---

Background: Much software involves running multiple processes. Often, this means a user session in web programming; at Ifbyphone, this means a particular phonecall.

Assignment: Given a log file, measure the time differences (deltas) between each event for a specific phonecall.

Usecase: You know a phonecall of this type has a particular flow. This specific phonecall has experienced an abnormal flow, and you need to see where it has deviated from the norm.

Tools: Basic Unix server environment.

Sample Logfile:

    DEBUG agi 2013-10-04 03:05:00.261 [unique-id] . . .
    INFO http 2013-10-04 03:05:00.274 [unique-id] . . .
    INFO http 2013-10-04 03:05:00.287 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:00.303 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:03.193 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:03.200 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:03.210 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:03.219 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:07.667 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:07.905 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.007 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.022 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.657 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.657 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.658 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.658 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.659 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.659 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.992 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.992 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.993 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:08.993 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:20.612 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:20.613 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:20.613 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:20.615 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:21.328 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:21.329 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:21.329 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:21.330 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:33.292 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:33.292 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:33.292 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:33.294 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:36.979 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:36.980 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:36.980 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:36.980 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:37.613 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:37.614 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:37.614 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:37.615 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.172 [unique-id] . . .
    DEBUG input 2013-10-04 03:05:42.173 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.173 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.425 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.425 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.425 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.425 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.677 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.677 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.677 [unique-id] . . .
    DEBUG agi 2013-10-04 03:05:42.679 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:28.707 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:28.708 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:28.708 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:28.709 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:29.343 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:29.343 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:29.344 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:29.344 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:32.932 [unique-id] . . .
    DEBUG input 2013-10-04 03:06:32.932 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:32.933 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.184 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.184 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.184 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.185 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.436 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.436 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.437 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:33.438 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:50.932 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:50.933 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:50.933 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:50.934 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:51.567 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:51.567 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:51.567 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:51.568 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.452 [unique-id] . . .
    DEBUG input 2013-10-04 03:06:55.452 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.452 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.704 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.704 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.705 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.705 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.956 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.957 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.957 [unique-id] . . .
    DEBUG agi 2013-10-04 03:06:55.958 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.268 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.268 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.269 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.270 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.271 [unique-id] . . .
    INFO http 2013-10-04 03:07:10.272 [unique-id] . . .
    INFO http 2013-10-04 03:07:10.277 [unique-id] . . .
    INFO http 2013-10-04 03:07:10.306 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.306 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.307 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.307 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.308 [unique-id] . . .
    INFO ahn 2013-10-04 03:07:10.308 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.309 [unique-id] . . .
    DEBUG agi 2013-10-04 03:07:10.310 [unique-id] . . .
    INFO ahn 2013-10-04 03:07:10.311 [unique-id] . . .
    INFO agi 2013-10-04 03:07:10.312 [unique-id] . . .

The log entry starts with a basic log-level notice, followed by the service, and then date and time. Between the brackets, you have a unique id associated with the phonecall. After the unique id, there's the contents of the log message.

Solution:

Grab the appropriate excerpt from the main logfile. Keep a copy of this excerpt for parsing.
    nice grep 'unique-id' main.log > /tmp/unique.log
    logfile=/tmp/unique.log
    timestamps=$logfile.timestamps

For convenience, extract *only the timestamps*. These we'll save for parsing.
    logfile=/tmp/unique.log
    timestamps=$logfile.timestamps
    cat $logfile | awk '{print $4}' > $timestamps

Now the fun part! We'll use sed to chop each timestamp into hour, minute, second, and millisecond pieces, then pipe those pieces to awk to do basic arithmetic.
    cat $timestamps | sed 's/[:.]/ /g' | awk '{ time = ($1*3600 + $2*60 + $3)*1000 + $4 }; NR==1{ prev = time}; {print time - prev }; {prev = time}'

If you're not familiar with awk, I'll break this down a bit more. It's not advanced, but I can understand how the syntax can be challenging if you're unfamiliar.

1. The first argument ($1) corresponds to hours, the second to minutes ($2), the third ($3) to seconds, and the fourth ($4) to milliseconds. We convert the entire timestamp to milliseconds with <code>($1*3600 + $2*60 + $3)*1000 + $4</code> and keep this conversion as the variable <code>time</code>.
2. If we're on the first line, <code>NR==1</code>, then we also assign the previous time to the current time <code>prev = time</code>.
3. We'll print the difference between the previous and the current time, <code> {print time - prev }</code>.
4. Finally, set the previous time to the current time. This will be done for *all* timestamps, notably *after* calculating the delta.

Here's the results, further parsed into a comma delineated list:

0, 13, 13, 16, 2890, 7, 10, 9, 4448, 238, 102, 15, 635, 0, 1, 0, 1, 0, 333, 0, 1, 0, 11619, 1, 0, 2, 713, 1, 0, 1, 11962, 0, 0, 2, 3685, 1, 0, 0, 633, 1, 0, 1, 4557, 1, 0, 252, 0, 0, 0, 252, 0, 0, 2, 46028, 1, 0, 1, 634, 0, 1, 0, 3588, 0, 1, 251, 0, 0, 1, 251, 0, 1, 1, 17494, 1, 0, 1, 633, 0, 0, 1, 3884, 0, 0, 252, 0, 1, 0, 251, 1, 0, 1, 14310, 0, 1, 1, 1, 1, 5, 29, 0, 1, 0, 1, 0, 1, 1, 1, 1

Which we can easily load into R for a quick and dirty visualization:

    data<-c(0, 13, 13, 16, 2890, 7, 10, 9, 4448, 238, 102, 15, 635, 0, 1, 0, 1, 0, 333, 0, 1, 0, 11619, 1, 0, 2, 713, 1, 0, 1, 11962, 0, 0, 2, 3685, 1, 0, 0, 633, 1, 0, 1, 4557, 1, 0, 252, 0, 0, 0, 252, 0, 0, 2, 46028, 1, 0, 1, 634, 0, 1, 0, 3588, 0, 1, 251, 0, 0, 1, 251, 0, 1, 1, 17494, 1, 0, 1, 633, 0, 0, 1, 3884, 0, 0, 252, 0, 1, 0, 251, 1, 0, 1, 14310, 0, 1, 1, 1, 1, 5, 29, 0, 1, 0, 1, 0, 1, 1, 1, 1)
    barplot(x, main="Event Deltas (ms) for unique-id", xlab="Events (in series)")

<img src="https://haiqus.com/rplot.png" alt="Event Deltas (ms) for unique-id" title="Event Deltas (ms) for unique-id" style="max-width:100%;" />
