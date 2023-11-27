# nashville-housing-project
This project contains a comprehensive analysis of the Nashville real estate market utilizing SQL and PowerBI. The project encompasses a significant data cleaning phase, ensuring high data quality. Leveraging Power BI, the analysis dives into key trends and insights shaping the real estate landscape in the Nashville region.

**Skills used:** 
- **SQL:** CTEs, Update, Convert, Self Joins, Substring, Charindex, Len, Alter Table, Substring, ParseName, Replace, Delete, Drop Column.
- **Power BI:** Data transformation (Copy Table, Remove Duplicates), DAX (Create Measure), Modeling (Fact Table and Dimension Table, Parameters) and Data Visualization (Cards, Line Charts, Bar Charts, Slicers).

**Data source:** https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data/

**Data range:** Jan/2020 - Jul/2023

# Data Cleaning

Below is an overview of the queries executed for cleaning the dataset:

- **Standardize Date Format:** Used a CONVERT function to display SaleDate in a consistent date format. Performed an UPDATE statement to apply the standardized date format.
- **Populate Property Address Data:** Used a JOIN statement to identify missing values in PropertyAddress. Applied an UPDATE statement to fill missing values with corresponding addresses. 
- **Breaking Out Address into Individual Columns (Address, City, State):** Used string manipulation functions (SUBSTRING, CHARINDEX, LEN) to separate address and city. Added new columns (PropertySplitAddress and PropertySplitCity) to the table. Updated these new columns with the split values. Used string manipulation and PARSENAME functions to extract the state. Added new columns (OwnerSplitAddress, OwnerSplitCity, OwnerSplitState) to the table. Updated these new columns with the split values.
- **Change Y and N to Yes and No in "Sold as Vacant" Field:** Created a new column with standardized values using a CASE statement. Updated the original column with the standardized values.
- **Remove Duplicates:** Used a Common Table Expression (CTE) with ROW_NUMBER() to identify and remove duplicates.
- **Delete Unused Columns:** Performed an ALTER TABLE statement to drop unnecessary columns.

  After all these transformations, the dataset integrated into PowerBI had the following columns:

- **UniqueID:** Unique identifier for each record.
- **ParcelID:** Parcel identifier.
- **LandUse:** Classification of land use.
- **SalePrice:** Price at which the property was sold.
- **LegalReference:** Legal reference for the property.
- **SoldAsVacant:** Indicates whether the property was sold as vacant.
- **OwnerName:** Name of the property owner.
- **Acreage:** Size of the property in acres.
- **LandValue:** Value of the land.
- **BuildingValue:** Value of the building.
- **TotalValue:** Total assessed value of the property.
- **YearBuilt:** Year the property was built.
- **Bedrooms:** Number of bedrooms in the property.
- **FullBath:** Number of full bathrooms.
- **HalfBath:** Number of half bathrooms.
- **PropertySplitAddress:** Address of the property.
- **PropertySplitCity:** City of the property.
- **OwnerSplitAddress:** Address of the property owner.
- **OwnerSplitCity:** City of the property owner.
- **OwnerSplitState:** State of the property owner.

