# Sales and Inventory Management System

## Overview

This project demonstrates a Sales and Inventory Management System using MS SQL Server. It includes SQL scripts for database creation, stored procedures, triggers, and other management functions, showcasing practical applications for efficiently handling sales and inventory data.

## Project Structure

- **`scripts/`**: Contains SQL scripts for setting up and managing the database.
  - **`db_scripts/`**: Includes scripts for creating tables, stored procedures, triggers, etc.
  - **`backup/`**: Contains the backup file for restoring the database.

## Getting Started

### Prerequisites

- **MS SQL Server**: You can use either a Docker container or a local installation on Windows.
- **MS SQL Client**: Azure Data Studio or SQL Server Management Studio (SSMS) for managing the database.

### Running the Project

1. **Clone the Repository**:
   
   Clone the repository to your local machine:
    ```bash
   git clone https://github.com/tymoteuszmilek/Automated-Sales-and-Inventory-Management-System.git
   cd Automated-Sales-and-Inventory-Management-System
    ```
    
## Set Up the Database:

You have two options to set up the database:

### Option 1: Restore from Backup

1. Open SQL Server Management Studio (SSMS) or Azure Data Studio.
2. Navigate to the **Restore Database** option.
3. Select the `.bak` file from the `backup/` folder.
4. Follow the on-screen instructions to restore the database.

### Option 2: Execute SQL Scripts

1. Open SQL Server Management Studio (SSMS) or Azure Data Studio.
2. Connect to your SQL Server instance.
3. Open and execute the SQL scripts located in the `scripts/db_scripts/` folder in the following order:
   - `db_initializer.sql`
   - `insert_data.sql`
4. Ensure all scripts execute without errors, and the database with sample data is successfully set up.

## Stored Procedures

The following stored procedures are included in the system to manage ordering/automated ordering and analysis.

1. **`CreateOrder`**  
   **Description**: Creates a new order for a given product ID.  
   **Parameters**:  
   - `@product_id` (INT): The ID of the product to order.  
   - `@quantity` (INT, default = 20): The quantity of the product to order.  
   **Example**:
   ```sql
   EXEC CreateOrder @product_id = 101, @quantity = 50;

2. **`CreateReorderForLowStockProducts`**  
   **Description**: Automatically creates a reorder for products that are below the minimum threshold stock level.  
   **Parameters**: None.    
   **Example**:
   ```sql
   EXEC CreateReorderForLowStockProducts;

3. **`GenerateWeeklySalesReport`**
   **Description**: Generates a report summarizing sales by category for the past week (day interval).
   **Parameters**: None.
   **Example**:
   ```sql
   EXEC GenerateWeeklySalesReport;
   ```
   

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/tymoteuszmilek/Automated-Sales-and-Inventory-Management-System/tree/main?tab=MIT-1-ov-file) file for details.
