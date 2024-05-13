Project Background

Introduction

This SQL project aims to create a dynamic dashboard for monitoring and analyzing a hypothetical investment portfolio. 
It is designed as part of a coursework assignment for the AFM 424 Equity Finance course at the University of Waterloo, where students engage in a simulation to manage a $100,000 portfolio. 

Data Source

The data originates from a portfolio management simulation, part of the AFM 424 Portfolio Management course. 
Students were tasked with buying a mix of equities and bonds and tracking their portfolio's performance over a semester. 
The simulation involves real-world market data but limits transactions to a single initial purchase, 
making the dataset unique and directly relevant to real-world market conditions albeit with constrained trading flexibility.

Inspiration

The project was inspired by the direct application of theoretical knowledge from the Equity Portfolio Management course. 
The simulation provided firsthand experience with investment strategies and portfolio management, sparking my interest to further explore these concepts.

SQL Project Overview

Database Structure

The database consists of three primary tables:

1) PriceHistory_Portfolio: Records daily closing prices of each asset throughout the simulation.
2) Industry: Maps each asset to an industry via industry IDs.
3) Trades: Contains details of each asset purchased on the first day of the simulation.


SQL Procedures

Three SQL stored procedures were developed to provide essential portfolio insights:

1) GetPortfolioHistory: Retrieves the daily balance, cashflow gains, and ROI of the entire portfolio.
2) GetAssetHistory: Provides the daily balance, cashflow gains, and ROI for individual assets.
3) GetPerformanceAttribution: Shows the distribution and returns of different asset types within the portfolio.

Key Concepts and SQL Functions

The project leverages various SQL features including dynamic SQL for flexible query generation, temporary tables for intermediate data storage, and stored procedures for encapsulating complex logic.

Limitations

Trading Constraints: The simulation only allowed for a single buying transaction on the opening day, which does not mimic typical trading scenarios where adjustments would be made over time.
Short Simulation Period: The data covers only the term length, which may not be sufficient to observe more substantial investment trends or the impact of longer-term strategies.

Installation and Usage

To utilize this SQL project, ensure that Microsoft SQL Server is installed. 
Import the provided Excel tables into your SQL database, and execute the SQL script to create the stored procedures. 
Use the procedures by passing the appropriate parameters as documented in the code comments.

Reflection

This project not only solidifies my SQL and data management skills but also enriches my understanding of portfolio dynamics in financial markets. 
It really serves as a practical bridge between academic theories and real-world application. I will continue to work on this project with time to explore more complex topics (Portfolio Diversification Analysis?)
using more SQL and data analysis concepts.
