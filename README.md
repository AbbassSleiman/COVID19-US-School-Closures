# COVID-19 US School Closures 

## Overview

This repo contains the data, `R` scripts and final `PDF` report used in a reproduction of Jack and Oster's "COVID-19, School Closures, and Outcomes" (2023), published in American Economic Association's *Journal of Economic Perspectives*.  This analysis furthers the original paper's discussion on the learning loss due to school closures during the COVID-19 pandemic in the context of the Netherlands. The paper concludes that the COVID-19 pandemic imposed significant costs of learning loss and widened inequality gaps in the United States and the Netherlands, with impacts likely largerin countries disenfranchised by weaker infrastructure or longer closures

A replication using the Social Science Reproduction was also produced: https://www.socialsciencereproduction.org/reproductions/8aab4425-63ad-47bc-93ef-82076d6e49cc/index 

Link to original paper: [https://onlinelibrary.wiley.com/doi/10.1111/ajps.12595](https://www.aeaweb.org/articles?id=10.1257/jep.37.4.51)

## File Structure

The repo is structured as follows:

-  `input/data` contains the data sources used in analysis including the raw and cleaned data. 
-   `input/llm` contains the entire chat history with LLM CHATGPT-3.5 
-   `input/sketches` contains brief sketches of potential datasets and tables used in the planning stage of this report. 
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate (`00-simulate_data.R`), download (`01-download_data.R`), clean (`02-data_cleaning.R`) and test data (`03-test_data.R`), as well as to replicate the important figures from the original paper (`99-replications.R`)

## LLM Usage  

No auto-complete tools such as co-pilot were used in the course of this project. However, CHATGPT-3.5 was used to aid in the writing of this paper. In particular, it was primarily used to aid with the coding aspect of the paper as opposed to the actual writing. The entire chat history can be found in `inputs/llm/usage.txt`. 
