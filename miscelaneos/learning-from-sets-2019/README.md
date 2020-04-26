# Dataset from Learning from Sets of Items in Recommender Systems

This dataset contains results from a survey about the users' ratings on sets of movies. More details about the dataset are present in the research paper "Learning from Sets of Items in Recommender Systems", published in the ACM Transactions on Interactive Intelligent Systems (TiiS), 2019. The data were collected on [movielens.org](http://movielens.org) between February and April 2016.

This readme was written by Mohit Sharma on April 10, 2019.


## Citation
Mohit Sharma, F.Maxwell Harper, and George Karypis, 2019. Learning from Sets of Items in Recommender Systems. In Proceedings of ACM Transactions on Interactive Intelligent Systems (TiiS), 2019, 27 pages. 


## Contact Information
If you have questions, contact Mohit Sharma <sharm163@umn.edu>.


## License
This work is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.


# Description of CSV files

General notes:

* Movie identifiers are consistent with those used in the MovieLens datasets: <https://grouplens.org/datasets/movielens/>
* User identifiers have been obfuscated to protect users' privacy.
* Both movie and user identifiers are consistent across this dataset.


## set_ratings.csv

This file contains the users' ratings on sets of five movies selected at random.

* userId      -- obfuscated user identifiers
* movieId_<i> -- MovieLens movie identifier of xth movie in set
* rating      -- rating provided by the user on the movies in set
* timestamp   -- date and time when the user provided rating on set


## item_ratings.csv

This file contains the users' individual ratings on movies in sets.

* userId    -- obfuscated user identifiers
* movieId   -- MovieLens movie identifier for a movie
* rating    -- rating provided by the user on the movie
* timestamp -- date and time when the user provided rating on the movie

