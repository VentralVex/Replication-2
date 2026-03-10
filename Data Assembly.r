library(tidyverse)
library(readxl)

# Build skeleton panel
countries <- c(
  "Russia", "Saudi Arabia", "Qatar", "Comoros", "Botswana", "Bahamas",
  "Oman", "Venezuela, RB", "Kuwait", "Papua New Guinea", "Libya",
  "South Africa", "Argentina", "Cuba", "Timor-Leste", "Brunei Darussalam",
  "United Arab Emirates", "Trinidad and Tobago", "Thailand", "Fiji",
  "Cameroon", "Namibia", "Romania", "Iran, Islamic Rep.", "Senegal",
  "Uruguay", "Nigeria", "Solomon Islands", "Latvia", "Belize", "Turkey",
  "Bhutan", "Bulgaria", "Malaysia", "Lao PDR", "Mexico", "Uzbekistan",
  "Lithuania", "Kazakhstan", "China", "Gabon", "Zimbabwe", "Tanzania",
  "Cote d'Ivoire", "Cyprus", "Togo", "Syrian Arab Republic", "Gambia",
  "Angola", "Cambodia", "Suriname", "Guinea-Bissau", "Cape Verde",
  "Algeria", "Mongolia", "Iraq", "Ukraine", "Belarus", "Panama",
  "Central African Republic", "Djibouti", "Benin", "Paraguay", "Niger",
  "Madagascar", "Albania", "Eritrea", "Swaziland", "Uganda", "Nepal",
  "Mali", "Guinea", "Malawi", "Zambia", "Burundi", "Chile", "Congo, Rep.",
  "Liberia", "Brazil", "Colombia", "Mauritius", "Lebanon", "Turkmenistan",
  "India", "Chad", "Congo, Dem. Rep.", "Ethiopia", "Sierra Leone",
  "Somalia", "Lesotho", "Dominican Republic", "Costa Rica", "Burkina Faso",
  "Philippines", "Ecuador", "Tunisia", "Rwanda", "Moldova", "Jamaica",
  "Afghanistan", "Ghana", "Morocco", "Kenya", "Mozambique",
  "Egypt, Arab Rep.", "Nicaragua", "Mauritania", "El Salvador", "Guyana",
  "Sudan", "Kyrgyz Republic", "Jordan", "Guatemala", "Pakistan",
  "Armenia", "Azerbaijan", "Sri Lanka", "Indonesia", "Peru", "Bolivia",
  "Tajikistan", "Honduras", "Haiti", "Georgia", "Bangladesh"
)

panel <- expand.grid(
  country = countries,
  year = 1971:2006,
  stringsAsFactors = FALSE
) |>
  arrange(country, year)

region_map <- c(
  # Asia and Pacific
  "Russia" = "Europe and Central Asia",
  "China" = "Asia and Pacific",
  "Thailand" = "Asia and Pacific",
  "Fiji" = "Asia and Pacific",
  "Papua New Guinea" = "Asia and Pacific",
  "Timor-Leste" = "Asia and Pacific",
  "Brunei Darussalam" = "Asia and Pacific",
  "Solomon Islands" = "Asia and Pacific",
  "Lao PDR" = "Asia and Pacific",
  "Malaysia" = "Asia and Pacific",
  "Cambodia" = "Asia and Pacific",
  "Mongolia" = "Asia and Pacific",
  "Philippines" = "Asia and Pacific",
  "Indonesia" = "Asia and Pacific",
  "Vietnam" = "Asia and Pacific",

  # Europe and Central Asia
  "Latvia" = "Europe and Central Asia",
  "Lithuania" = "Europe and Central Asia",
  "Romania" = "Europe and Central Asia",
  "Bulgaria" = "Europe and Central Asia",
  "Albania" = "Europe and Central Asia",
  "Ukraine" = "Europe and Central Asia",
  "Belarus" = "Europe and Central Asia",
  "Moldova" = "Europe and Central Asia",
  "Armenia" = "Europe and Central Asia",
  "Azerbaijan" = "Europe and Central Asia",
  "Georgia" = "Europe and Central Asia",
  "Kazakhstan" = "Europe and Central Asia",
  "Uzbekistan" = "Europe and Central Asia",
  "Turkmenistan" = "Europe and Central Asia",
  "Kyrgyz Republic" = "Europe and Central Asia",
  "Tajikistan" = "Europe and Central Asia",
  "Turkey" = "Europe and Central Asia",
  "Cyprus" = "Europe and Central Asia",

  # Latin America and Caribbean
  "Venezuela, RB" = "Latin America and Caribbean",
  "Argentina" = "Latin America and Caribbean",
  "Cuba" = "Latin America and Caribbean",
  "Trinidad and Tobago" = "Latin America and Caribbean",
  "Uruguay" = "Latin America and Caribbean",
  "Belize" = "Latin America and Caribbean",
  "Mexico" = "Latin America and Caribbean",
  "Panama" = "Latin America and Caribbean",
  "Paraguay" = "Latin America and Caribbean",
  "Chile" = "Latin America and Caribbean",
  "Brazil" = "Latin America and Caribbean",
  "Colombia" = "Latin America and Caribbean",
  "Jamaica" = "Latin America and Caribbean",
  "Dominican Republic" = "Latin America and Caribbean",
  "Costa Rica" = "Latin America and Caribbean",
  "Ecuador" = "Latin America and Caribbean",
  "Nicaragua" = "Latin America and Caribbean",
  "El Salvador" = "Latin America and Caribbean",
  "Guyana" = "Latin America and Caribbean",
  "Guatemala" = "Latin America and Caribbean",
  "Peru" = "Latin America and Caribbean",
  "Bolivia" = "Latin America and Caribbean",
  "Honduras" = "Latin America and Caribbean",
  "Haiti" = "Latin America and Caribbean",
  "Suriname" = "Latin America and Caribbean",
  "Bahamas" = "Latin America and Caribbean",

  # Middle East and North Africa
  "Saudi Arabia" = "Middle East and North Africa",
  "Qatar" = "Middle East and North Africa",
  "Oman" = "Middle East and North Africa",
  "Kuwait" = "Middle East and North Africa",
  "Libya" = "Middle East and North Africa",
  "Iran, Islamic Rep." = "Middle East and North Africa",
  "Iraq" = "Middle East and North Africa",
  "Syrian Arab Republic" = "Middle East and North Africa",
  "Lebanon" = "Middle East and North Africa",
  "Jordan" = "Middle East and North Africa",
  "Algeria" = "Middle East and North Africa",
  "Tunisia" = "Middle East and North Africa",
  "Egypt, Arab Rep." = "Middle East and North Africa",
  "Mauritania" = "Middle East and North Africa",
  "Morocco" = "Middle East and North Africa",
  "United Arab Emirates" = "Middle East and North Africa",
  "Djibouti" = "Middle East and North Africa",
  "Yemen, Rep." = "Middle East and North Africa",

  # South Asia
  "India" = "South Asia",
  "Pakistan" = "South Asia",
  "Bangladesh" = "South Asia",
  "Sri Lanka" = "South Asia",
  "Nepal" = "South Asia",
  "Bhutan" = "South Asia",
  "Afghanistan" = "South Asia",

  # Sub-Saharan Africa
  "Comoros" = "Sub-Saharan Africa",
  "Botswana" = "Sub-Saharan Africa",
  "South Africa" = "Sub-Saharan Africa",
  "Cameroon" = "Sub-Saharan Africa",
  "Namibia" = "Sub-Saharan Africa",
  "Senegal" = "Sub-Saharan Africa",
  "Nigeria" = "Sub-Saharan Africa",
  "Zimbabwe" = "Sub-Saharan Africa",
  "Tanzania" = "Sub-Saharan Africa",
  "Cote d'Ivoire" = "Sub-Saharan Africa",
  "Togo" = "Sub-Saharan Africa",
  "Gambia" = "Sub-Saharan Africa",
  "Angola" = "Sub-Saharan Africa",
  "Guinea-Bissau" = "Sub-Saharan Africa",
  "Cape Verde" = "Sub-Saharan Africa",
  "Central African Republic" = "Sub-Saharan Africa",
  "Benin" = "Sub-Saharan Africa",
  "Niger" = "Sub-Saharan Africa",
  "Madagascar" = "Sub-Saharan Africa",
  "Eritrea" = "Sub-Saharan Africa",
  "Swaziland" = "Sub-Saharan Africa",
  "Uganda" = "Sub-Saharan Africa",
  "Mali" = "Sub-Saharan Africa",
  "Guinea" = "Sub-Saharan Africa",
  "Malawi" = "Sub-Saharan Africa",
  "Zambia" = "Sub-Saharan Africa",
  "Burundi" = "Sub-Saharan Africa",
  "Congo, Rep." = "Sub-Saharan Africa",
  "Liberia" = "Sub-Saharan Africa",
  "Mauritius" = "Sub-Saharan Africa",
  "Chad" = "Sub-Saharan Africa",
  "Congo, Dem. Rep." = "Sub-Saharan Africa",
  "Ethiopia" = "Sub-Saharan Africa",
  "Sierra Leone" = "Sub-Saharan Africa",
  "Somalia" = "Sub-Saharan Africa",
  "Lesotho" = "Sub-Saharan Africa",
  "Burkina Faso" = "Sub-Saharan Africa",
  "Rwanda" = "Sub-Saharan Africa",
  "Ghana" = "Sub-Saharan Africa",
  "Kenya" = "Sub-Saharan Africa",
  "Mozambique" = "Sub-Saharan Africa",
  "Sudan" = "Sub-Saharan Africa",
  "Gabon" = "Sub-Saharan Africa"
)

panel <- panel |>
  mutate(region = region_map[country])

# Import conflict data
conflict <- read_excel("C:/Users/aditr/Downloads/Replication Exercise 2/2010_c_666956-l_1-k_ucdp_prio_armedconflictdataset_v4_2010.xls")

# Reshape and create conflict indicators
conflict_long <- conflict |>
  select(YEAR, SideA, SideB, Type) |>
  filter(YEAR >= 1971, YEAR <= 2006) |>
  pivot_longer(cols = c(SideA, SideB), names_to = "side", values_to = "country") |>
  select(year = YEAR, country, Type) |>
  distinct(year, country, Type) |>
  mutate(
    has_conflict = 1,
    has_intrastate = as.integer(Type %in% c(1, 2, 4)),
    has_interstate = as.integer(Type == 3)
  )

panel <- panel |>
  left_join(conflict_long, by = c("country", "year")) |>
  mutate(
    has_conflict = replace_na(has_conflict, 0),
    has_intrastate = replace_na(has_intrastate, 0),
    has_interstate = replace_na(has_interstate, 0)
  ) |>
  select(-Type)

# Generate food aid received
food_aid <- read_csv("C:/Users/aditr/Downloads/Replication Exercise 2/US Food Aid - foodaid.csv") |>
  rename(country = `Recipient Country`, year = Year, wheat_aid = Value) |>
  select(country, year, wheat_aid)

panel <- panel |>
  left_join(food_aid, by = c("country", "year")) |>
  mutate(wheat_aid = replace_na(wheat_aid, 0))

# Generate US wheat production data
us_wheat_prod <- read_csv(
  "C:/Users/aditr/Downloads/Replication Exercise 2/US Annual Wheat Production - WheatYearbookTable04-Full.csv",
  skip = 1
) |>
  rename(year = `Marketing year\n1/`, us_wheat_prod = `U.S. production million bushels`) |>
  select(year, us_wheat_prod) |>
  mutate(
    year = as.integer(year),
    us_wheat_prod = as.numeric(str_remove_all(us_wheat_prod, ","))
  ) |>
  filter(year >= 1971, year <= 2006)

panel <- panel |>
  left_join(us_wheat_prod, by = "year")

# Generate population
population <- read_csv("C:/Users/aditr/Downloads/Replication Exercise 2/World Population - worldbankpop.csv") |>
  rename(country = `Country Name`) |>
  select(country, `1971 [YR1971]`:`2006 [YR2006]`) |>
  pivot_longer(
    cols = `1971 [YR1971]`:`2006 [YR2006]`,
    names_to = "year",
    values_to = "population"
  ) |>
  mutate(
    year = as.integer(str_extract(year, "\\d{4}")),
    population = as.numeric(population),
    country = case_when(
      country == "Russian Federation" ~ "Russia",
      TRUE ~ country
    )
  )

panel <- panel |>
  left_join(population, by = c("country", "year"))

# Generate real GDP per capita
GDPPC <- read_excel("C:/Users/aditr/Downloads/Replication Exercise 2/API_NY.GDP.PCAP.CD_DS2_en_excel_v2_281.xls", skip = 3)

GDPPC_long <- GDPPC |>
  select(`Country Name`, `1971`:`2006`) |>
  pivot_longer(cols = `1971`:`2006`, names_to = "year", values_to = "real_GDPPC") |>
  mutate(year = as.integer(year)) |>
  rename(country = `Country Name`)

panel <- panel |>
  left_join(GDPPC_long, by = c("country", "year"))

# Generate indicator of whether a Democrat was US president that year
panel <- panel |>
  mutate(democratic_president = as.integer(year %in% c(1977:1980, 1993:2000)))

# Generate real oil price
oil_price <- read_csv("C:/Users/aditr/Downloads/Replication Exercise 2/oil-prices-inflation-adjusted.csv") |>
  rename(year = Year, real_oil_price = `Oil price - Crude prices since 1861`) |>
  select(year, real_oil_price)

panel <- panel |>
  left_join(oil_price, by = "year")

# Generate average per capita net imports of cereal
cereal <- read_csv("C:/Users/aditr/Downloads/Replication Exercise 2/Average Recipient Cereal - globalcereal_importexport.csv") |>
  rename(country = Area, year = Year, m49 = `Area Code (M49)`, element = Element, value = Value) |>
  mutate(country = case_when(
    m49 == 68 ~ "Bolivia",
    m49 == 364 ~ "Iran, Islamic Rep.",
    m49 == 862 ~ "Venezuela, RB",
    TRUE ~ country
  )) |>
  filter(year >= 1971, year <= 2006) |>
  select(country, year, element, value)

cereal_net_imports <- cereal |>
  mutate(signed_value = if_else(element == "Export Quantity", -value, value)) |>
  group_by(country, year) |>
  summarise(net_imports_cereals = sum(signed_value, na.rm = TRUE), .groups = "drop")

panel <- panel |>
  left_join(cereal_net_imports, by = c("country", "year")) |>
  mutate(net_imports_cereals = replace_na(net_imports_cereals, 0)) |>
  group_by(country) |>
  mutate(avg_net_imports_cereals_pc = mean(net_imports_cereals / population, na.rm = TRUE)) |>
  ungroup() |>
  select(-net_imports_cereals)

# Generate average per capita cereal production
cereal_prod <- read_csv("C:/Users/aditr/Downloads/Replication Exercise 2/Average Recipient Cereal - globalcerealprod.csv") |>
  rename(country = Area, year = Year, m49 = `Area Code (M49)`, cereal_prod = Value) |>
  mutate(country = case_when(
    m49 == 68 ~ "Bolivia",
    m49 == 364 ~ "Iran, Islamic Rep.",
    m49 == 862 ~ "Venezuela, RB",
    TRUE ~ country
  )) |>
  filter(year >= 1971, year <= 2006) |>
  select(country, year, cereal_prod)

cereal_prod_pc <- cereal_prod |>
  left_join(population, by = c("country", "year")) |>
  group_by(country) |>
  summarise(avg_cereal_prod_pc = mean(cereal_prod / population, na.rm = TRUE)) |>
  ungroup()

# Merge onto panel
panel <- panel |>
  left_join(cereal_prod_pc, by = "country") |>
  mutate(avg_cereal_prod_pc = replace_na(avg_cereal_prod_pc, 0))

# Sanity check
panel |>
  slice_sample(n = 10) |>
  print(width = Inf)
