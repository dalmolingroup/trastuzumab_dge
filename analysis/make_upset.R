library(here)
library(readr)
library(dplyr)
library(tidyr)
library(UpSetR)

data <- read_csv(here("data/selected_genes_grouped.csv"), skip = 1) %>%
  janitor::clean_names() %>%
  dplyr::select(gene_symbol, grouped_process) %>%
  distinct()

data_encoded_source <- data %>%
  filter(!is.na(grouped_process)) %>%
  mutate(n = 1) %>%
  pivot_wider(
    id_cols     = gene_symbol,
    names_from  = grouped_process,
    values_from = n,
    values_fn   = list(n = length),
    values_fill = list(n = 0)
  ) %>%
  as.data.frame()

upset_p <- upset(
  nsets = 4,
  data_encoded_source,
  order.by = "freq",
  empty.intersections = "on"
)

pdf(file=here("results/upset_plot.pdf"), width = 8, height = 5.5)
upset_p
dev.off()

png(file=here("results/upset_plot.png"), width = 8, height = 5.5, units = "in", res=500)
upset_p
dev.off()
