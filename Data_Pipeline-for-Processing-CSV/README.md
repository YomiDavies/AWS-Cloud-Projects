# Data_Pipeline-for-Processing-CSV

![te](https://github.com/YomiDavies/Data_Pipeline-for-Processing-CSV/blob/main/Architecture%20for%20DataPipeline%20processing.jpeg)

🚀 Project Highlight: Building a Serverless Data Pipeline on AWS

I’m excited to share a recent project where I designed and deployed a serverless data pipeline using AWS to automate the ingestion, transformation, and visualization of CSV data.

Here’s how the pipeline works:

📥 Data Ingestion: CSV files are uploaded to an S3 bucket, acting as the central storage for both raw and processed data.
⚙️ Trigger & Transformation: An AWS Lambda function is automatically triggered to clean and reformat the data, which is then passed to AWS Glue for deeper ETL operations.
🗂️ Data Storage: The processed data is stored in a dedicated S3 bucket.
📊 Visualization: Amazon QuickSight connects to the final dataset and generates interactive dashboards and reports.

🛠️ Services Used:

Amazon S3 – Storage for raw and processed data

AWS Lambda – Serverless processing for automation

AWS Glue – ETL operations for structured transformation

Amazon QuickSight – Dashboards and reporting

IAM Roles & Policies – Securing inter-service access

This project helped sharpen my skills in cloud automation, serverless computing, and real-time data visualization—all in a production-style environment. It’s a great example of building modern solutions without managing infrastructure.
