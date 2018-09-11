## Inspiration
Let’s take you through a simple encounter between a recruiter and an aspiring student looking for a job during a career fair. The student greets the recruiter eagerly after having to wait in a 45 minute line and hands him his beautifully crafted paper resume. The recruiter, having been talking to thousands of students knows that his time is short and tries to skim the article rapidly, inevitably skipping important skills that the student brings to the table. In the meantime, the clock has been ticking and while the recruiter is still reading non-relevant parts of the resume the student waits, blankly staring at the recruiter. The recruiter finally looks up only to be able to exchange a few words of acknowledge and a good luck before having to move onto the next student. And the resume? It ends up tossed in the back of a bin and jumbled together with thousands of other resumes. The clear bottleneck here is the use of the paper Resume.

Instead of having the recruiter stare at a thousand word page crammed with everything someone has done with their life, it would make much more sense to have the student be able to show his achievements in a quick, easy way and have it elegantly displayed for the recruiter. 

With Reko, both recruiters and students will be geared for an easy, digital way to transfer information.

## What it does
By allowing employers and job-seekers to connect in a secure and productive manner, Reko calls forward a new era of stress free peer-to-peer style data transfer. The magic of Reko is in its simplicity. Simply walk up to another Reko user, scan their QR code (or have them scan yours!), and instantly enjoy a UX rich file transfer channel between your two devices. During PennApps, we set out to demonstrate the power of this technology in what is mainly still a paper-based ecosystem: career fairs. 

With Reko, employers no longer need to peddle countless informational pamphlets, and students will never again have to rush to print out countless resume copies before a career fair. Not only can this save a large amount of paper, but it also allows students to freely choose what aspects of their resumes they want to accentuate. Reko also allows employers to interact with the digital resume cards sent to them by letting them score each card on a scale of 1 - 100. Using this data alongside machine learning, Reko then provides the recruiter with an estimated candidate match percentage which can be used to streamline the hiring process. Reko also serves to help students by providing them a recruiting dashboard. This dashboard can be used to understand recruiter impressions and aims to help students develop better candidate profiles and resumes.

## How we built it
### Front-End // Swift
The frontend of Reko focuses on delivering a phenomenal user experience through an exceptional user interface and efficient performance. We utilized native frameworks and a few Cocoapods to provide a novel, intriguing experience. The QR code exchange handshake protocol is accomplished through the very powerful VisionKit. The MVVM design pattern was implemented and protocols were introduced to make the most out of the information cards. The hardest implementation was the Web Socket implementation of the creative exchange of the information cards — between the student and interviewer.

### Back-End // Node.Js
The backend of Reko focuses on handling websocket sessions, establishing connection between front-end and our machine learning service, and managing the central MongoDB.
Every time a new ‘user-pair’ is instantiated via a QR code scan, the backend stores the two unique socket machine IDs as ‘partners’, and by doing so is able to handle what events are sent to one, or both partners. By also handling the MongoDB, Reko’s backend is able to relate these unique socket IDs to stored user account’s data. In turn, this allows Reko to take advantage of data sets to provide the user with valuable unique data analysis. Using the User ID as context, Reko’s backend is able to POST our self-contained Machine Learning web service. Reko’s ML web service responded with an assortment of statistical data, which is then emitted to the front-end via websocket for display & view by the user.

### Machine Learning // Python
In order to properly integrate machine learning into our product, we had to build a self-contained web application. This container application was built on a virtual environment with a REST API layer and Django framework. We chose to use these technologies because they are scalable and easy to deploy to the cloud. With the Django framework, we used POST to easily communicate with the node backend and thus increase the overall workflow via abstraction. We were then able to use Python to train a machine learning model based on data sent from the node backend. After connecting to the MongoDB with the pymongo library, we were able to prepare training and testing data sets. We used the pandas python library to develop DataFrames for each data set and built a machine learning model using the algorithms from the scikit library. We tested various algorithms with our dataset and finalized a model that utilized the Logistic Regression algorithm. Using these data sets and the machine learning model, our service can predict the percentage a candidate matches to a recruiter’s job profile. The final container application is able to receive data and return results in under 1 second and is over 90% accurate.

## Challenges we ran into
- Finding a realistic data set to train our machine learning model
- Deploying our backend to the cloud
- Configuring the container web application
- Properly populating our MongoDB
- Finding the best web service for our use case
- Finding the optimal machine learning for our data sets


## Accomplishments that we're proud of
- UI/UX Design
- Websocket implementation
- Machine Learning integration
- Scalably structured database
- Self-contained Django web application

## What we learned
- Deploying container applications on the cloud
- Using MongoDB with Django
- Data Modeling/Analysis for our specific use case
- Good practices in structuring a MongoDB database as opposed to a SQL database.
- How to successfully integrate three software layers to generate a consistent and fluid final product.
- Strategies for linking iOS devices in a peer-to-peer fashion via websockets.

## What's next for reko
- Our vision for Reko is to have an app which allows for general and easy to use data transfer between two people who may be complete strangers. 
- We hope to transfer from QR code to NFC to allow for even easier data transfer and thus better user experience.
- We believe that a data transfer system such as the one Reko showcases is the future of in-person data transfer due to its “no-username” operation. This system allows individuals to keep their anonymity if desired, and thus protects their privacy.

