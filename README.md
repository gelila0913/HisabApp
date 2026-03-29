# HisabApp
##Multi-Branch Stock & Sales Management System

## 1. Project Overview
**HisabApp** is an offline-first mobile application built with Flutter. It serves as a comprehensive business utility for retail owners who manage multiple independent locations in areas with limited or unreliable internet connectivity.

### The Main Purpose
The system acts as a digital bridge between independent branches and a central owner. It replaces traditional, error-prone paper ledgers with a structured digital database, ensuring that every transaction is logged, every expense is accounted for, and inventory levels are always accurate across any product category.

### The Goal
* **For the Owner:** To minimize the hardship of manually managing diverse stock across different locations. **HisabApp** automates the complex calculation of net profit, total income, and sales staff salaries, removing the need for manual math and constant physical supervision.
* **For the Cashier:** To eliminate the burden of paper-based recording. The app simplifies daily tasks by automating stock subtraction, providing instant access to historical sales data (often lost in paper logs), and automatically calculating daily branch income and expenses.

---

## 2. Team Members
| Full Name | ID | 
| :--- | :--- | :--- |
| [Abrham Yonatan] | [] | 
| [Gelila Sintayehu] | [ugr/3508/16] | 
| [kidist Nega] | [ UGR/1923/16] | 
| [Nabon Amanuel] | [UGR/7416/16] | 
| [Victory Bedru] | [UGR/4541/16] | 

---

## 3. Key Features

### **Feature 1: Universal Inventory & Stock Management (CRUD)**
* **Digital Stock Ledger:** Cashiers can add any retail product with detailed specifications (Name, Model/Type, Category, and specific Attributes).
* **Automatic Stock Subtraction:** As sales are recorded, the app automatically updates remaining inventory for that specific item, preventing overselling.
* **Inventory Alerts:** Dashboard notifications for **Low Stock** (to prompt reordering) and **High Stock** (to manage storage space).
* **Branch-Specific Catalogs:** Inventory is isolated by branch so the Cashier focuses only on their assigned local stock.

### **Feature 2: Sales Recording & Personnel Management (CRUD)**
* **Product Sales Receipts:** Captures customer info (Name, Phone), product details, and the specific salesperson for every transaction.
* **Historical Data Retrieval:** Unlike paper logs, the Cashier can instantly search and find earlier sales data using date filters to resolve customer queries or audits.
* **Staff Performance Tracking:** Manages a list of active sales personnel and tracks exactly how many units each individual has sold to ensure accountability.

### **Feature 3: Manual Data Synchronization (The "Sync")**
* **Nightly Summary Table:** The app generates a summarized report (Product Type, Model, Quantity, and Staff) at the end of the day.
* **Asynchronous Transfer:** The Cashier sends a screenshot or export of this report to the Owner via external platforms (e.g., Telegram or WhatsApp).
* **Owner Aggregation:** The Owner uses a **"Smart Form"** in HisabApp to input the report data, which then updates global income and staff salary metrics.

### **Feature 4: Financial & Profit Intelligence**
* **Net Profit Engine:** Automatically calculates profit based on sales revenue minus cost of goods and operational expenses.
* **Salary & Expense Management:** Tracks staff sales counts to simplify salary/commission calculations and logs all business expenses (transport, rent, purchases, and miscellaneous costs).

---

## 4. Role-Based Access Control (RBAC) & Restrictions
To maintain business security and data privacy, the following restrictions are strictly enforced within **HisabApp**:

### **Owner Role (Full Administrative Access)**
* Create and delete branch profiles.
* View global analytics: Total income, total inventory value, and net profit across **all** branches.
* Manage global costs (Salaries, Transportation, Bulk Product Purchases).
* Perform manual data sync by inputting daily reports received from Cashiers.

### **Cashier Role (Restricted Branch Access)**
* **Financial Privacy:** The Cashier is **strictly prohibited** from seeing the Owner’s global costs, total business profit, or total company income.
* **Operational Isolation:** The Cashier cannot see reports, stock levels, or sales data from any other branch.
* **Local Focus:** Access is limited to managing their assigned branch's stock, recording daily sales, logging local costs, and viewing their own branch's daily income.

---

## 5. Technical Specifications
* **Architecture:** **Domain-Driven Design (DDD)** (Domain, Infrastructure, Application, and Presentation layers).
* **Persistence:** **SQLite** for 100% offline data integrity on the mobile device.
* **Backend:** Custom **Local REST API** (running on localhost); no Firebase or cloud services used.
* **Testing:** Comprehensive Unit, Widget, and Integration tests as per project requirements.

---

## 6. How It Works: The Workflow
1.  **Operation:** Cashier records sales and costs digitally in **HisabApp**, replacing paper logs for any retail product.
2.  **Reporting:** Cashier shares the daily summary table with the Owner via a screenshot or message.
3.  **Sync:** Owner enters the summary into the **"Smart Form"** in HisabApp, selecting the corresponding branch and product.
4.  **Analysis:** The app automatically updates the Owner’s dashboard with profit, salary data, and inventory balances.# HisabApp
