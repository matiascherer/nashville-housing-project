/*

Cleaning Data in SQL  Queries

*/

SELECT *
FROM NashvilleHousing

-------------------------------------------------------------------------------
-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------

-- Populate Property Address data

SELECT a.UniqueID, a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, b.UniqueID, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL AND a.[UniqueID ] <> b.[UniqueID ]

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL AND a.[UniqueID ] <> b.[UniqueID ]

-------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM NashvilleHousing
ORDER BY ParcelID

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress, 1)-1) AS Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, 1)+2, LEN(PropertyAddress)) AS City
FROM NashvilleHousing

ALTER TABLE NashVilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress, 1)-1)
FROM NashvilleHousing

ALTER TABLE NashVilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, 1)+2, LEN(PropertyAddress))
FROM NashvilleHousing

-- Separando o nome do estado:

SELECT PropertyAddress, OwnerAddress, SUBSTRING(OwnerAddress, LEN(PropertyAddress)+2, 3)	
FROM NashvilleHousing

--or

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashVilleHousing

-- Updating the table

ALTER TABLE NashVilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashVilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashVilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM NashvilleHousing

-------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant  ='Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant  ='Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
END

-------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID
				) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

-------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM NashvilleHousing

ALTER TABLE NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashVilleHousing
DROP COLUMN SaleDate

-- PowerBI Views Tests -----------------------------------------------------------------------------------------

SELECT AVG(SalePrice)/AVG(Acreage)
FROM NashvilleHousing

SELECT SUM(SalePrice)/(SUM(Acreage)*43560)
FROM NashvilleHousing
WHERE SalePrice IS NOT NULL AND Acreage IS NOT NULL

SELECT COUNT(1)
FROM NashvilleHousing
WHERE SalePrice > 0

SELECT PropertySplitCity, ROUND(SUM(SalePrice)/(SUM(Acreage)*43560),1) US$_SquareFeet
FROM NashvilleHousing
WHERE 
	Acreage IS NOT NULL 
	AND YearBuilt IS NOT NULL
	AND Bedrooms IS NOT NULL
	AND YearBuilt <=1981 
	AND YearBuilt > 1899
	AND Acreage <= 29
	AND Acreage > 7.49
	AND Bedrooms = 4
GROUP BY PropertySplitCity
ORDER BY SUM(SalePrice)/(SUM(Acreage)*43560) DESC

SELECT COUNT(1), ROUND(SUM(SalePrice)/(SUM(Acreage)*43560),2)
FROM NashvilleHousing
WHERE 
	Acreage IS NOT NULL 
	AND YearBuilt IS NOT NULL
	AND Bedrooms IS NOT NULL
	AND YearBuilt <=1981 
	AND YearBuilt > 1899
	AND Acreage <= 29
	AND Acreage > 7.49
	AND Bedrooms = 4

SELECT ROUND(SUM(SalePrice)/(SUM(Acreage)*43560),2)
FROM NashvilleHousing
WHERE 
	Acreage IS NOT NULL 
	AND YearBuilt IS NOT NULL
	AND YearBuilt <=1981
	AND Acreage <= 29
	AND Bedrooms = 4
