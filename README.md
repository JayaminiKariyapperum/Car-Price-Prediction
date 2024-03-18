Used Car Price Prediction System

Welcome to the Used Car Price Prediction System GitHub repository! This project is designed to predict the price of used cars based on various features using a Shiny web application.

Introduction

The Used Car Price Prediction System utilizes machine learning techniques to predict the price of used cars. It provides an interactive interface powered by Shiny, allowing users to input car details such as company, model, year, kilometers driven, and fuel type to obtain predicted prices.

Features

Interactive Interface: Utilizes Shiny web application for user-friendly interaction.
Predictive Modeling: Incorporates a linear regression model trained on historical car data to predict prices.
Data Visualization: Presents the price fluctuation of the selected car model over the years through an interactive plot.
Customization: Allows users to input various car details to obtain personalized price predictions.

Installation

To run the Used Car Price Prediction System locally, follow these steps:
Clone the repository to your local machine:

	git clone https://github.com/JayaminiKariyapperum/used-car-price-prediction.git

Open the R script app.R in RStudio.
Install the required packages if not already installed:

	install.packages(c("shiny", "caret", "ggplot2"))

Run the Shiny application by clicking on the "Run App" button in RStudio.

Usage

After launching the Shiny application, follow these steps to predict car prices:

Select the car company from the dropdown menu.
Choose the car model corresponding to the selected company.
Enter the year of the car.
Input the number of kilometers driven.
Select the fuel type of the car.
Click on the "Predict Price" button to obtain the predicted price.

Contributing

Contributions to the Used Car Price Prediction System are welcome! If you have ideas for improvements, new features, or bug fixes, feel free to submit a pull request. For major changes, please open an issue first to discuss the proposed changes.
