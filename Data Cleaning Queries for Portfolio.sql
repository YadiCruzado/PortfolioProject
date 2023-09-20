
/*
Data Cleaning Queries
*/


SELECT *
FROM [dbo].[HousingInfo]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT SaleDate, CONVERT(Date,SaleDate) AS SaleDateConverted
FROM [dbo].[HousingInfo]


Update [dbo].[HousingInfo]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [dbo].[HousingInfo]
Add SaleDateConverted Date;

Update [dbo].[HousingInfo]
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM [dbo].[HousingInfo]
--WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[HousingInfo] a
JOIN [dbo].[HousingInfo] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[HousingInfo] a
JOIN [dbo].[HousingInfo] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM [dbo].[HousingInfo]
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM [dbo].[HousingInfo]


ALTER TABLE [dbo].[HousingInfo]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[HousingInfo]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [dbo].[HousingInfo]
Add PropertySplitCity Nvarchar(255);

Update [dbo].[HousingInfo]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




SELECT *
FROM [dbo].[HousingInfo]





SELECT OwnerAddress
FROM [dbo].[HousingInfo]


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [dbo].[HousingInfo]



ALTER TABLE [dbo].[HousingInfo]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[HousingInfo]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [dbo].[HousingInfo]
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[HousingInfo]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [dbo].[HousingInfo]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[HousingInfo]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT *
FROM [dbo].[HousingInfo]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM [dbo].[HousingInfo]
GROUP BYSoldAsVacant
ORDER BY 2


-- Case Statement 

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [dbo].[HousingInfo]


Update [dbo].[HousingInfo]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Removing duplicates with cte

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

FROM [dbo].[HousingInfo]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



SELECT *
FROM [dbo].[HousingInfo]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM [dbo].[HousingInfo]


ALTER TABLE [dbo].[HousingInfo]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate