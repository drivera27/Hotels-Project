-- create revenue table
-- create a revenue column and drop cancelled bookings
CREATE VIEW revenue_table AS (
	SELECT
		h.hotel,
		h.arrival_date_year,
		h.arrival_date_month,
		h.stays_in_week_nights + h.stays_in_weekend_nights AS nights_total,
		h.adr,
		ms.Discount,
		ROUND(
			((h.stays_in_week_nights + h.stays_in_weekend_nights) * h.adr) * (1 - ms.Discount)
			, 2) AS revenue
	FROM Hotels h
	JOIN MarketSegment ms
		ON h.market_segment = ms.market_segment
	WHERE h.is_canceled = 0
)

-- revenue by month
SELECT arrival_date_month, ROUND(SUM(revenue), 2) AS monthly_revenue
FROM revenue_table
GROUP BY arrival_date_month
ORDER BY monthly_revenue DESC;

-- revenue by year
SELECT arrival_date_year, ROUND(SUM(revenue), 2) AS yearly_revenue
FROM revenue_table
GROUP BY arrival_date_year
ORDER BY arrival_date_year;

-- revenue by hotel and year
SELECT hotel, arrival_date_year, ROUND(sum(revenue), 2) AS yearly_revenue
FROM revenue_table
GROUP BY hotel, arrival_date_year
ORDER BY hotel, arrival_date_year;