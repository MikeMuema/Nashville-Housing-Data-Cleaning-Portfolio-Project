/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE,SaleDate)
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

UPDATE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET SaleDate = CONVERT(DATE,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
ADD SaleDateConverted Date;

UPDATE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET SaleDateConverted = CONVERT(DATE,SaleDate)

SELECT SaleDateConverted
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

-- Populate Property Address data

SELECT *
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$] a
JOIN [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$] a
JOIN [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress)) AS Propertycity
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Add PropertyCity Nvarchar(255);

Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

Select OwnerAddress
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]


ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Add OwnerSplitState Nvarchar(255);

Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]



-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]


Update [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


SELECT *
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_num
FROM [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
)
--order by ParcelID
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

-- Delete Unused Columns

Select *
From [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]

ALTER TABLE [Nashville_Housing_Data].[dbo].[Nahville_Housing_Data$]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





