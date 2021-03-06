# Copyright 2014-2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

testthat::context("Unit tests for single_pre_post.R")

test_that("SinglePrePost", {
  n <- 100
  mu.pre <- 10
  mu.trmt <- 2
  mu.ctrl <- 0
  ctrl.data <- data.frame(pre = rnorm(n, mu.pre),
                          condition = rep("control", n),
                          stringsAsFactors = FALSE)
  ctrl.data$post <- ctrl.data$pre + rnorm(n, mu.ctrl)
  trmt.data <- data.frame(pre = rnorm(n, mu.pre),
                          condition = rep("treatment", n),
                          stringsAsFactors = FALSE)
  trmt.data$post <- trmt.data$pre + rnorm(n, mu.trmt)
  data <- dplyr::bind_rows(ctrl.data, trmt.data)
  ans <- abpackage:::SinglePrePost(data)
  expect_equal(dim(ans), c(2, 7))
  expect_equal(names(ans),
               c("lower", "center", "upper", "mean", "var", "p.value", "type"))
})


test_that("WeightedAverage", {
  x.1 <- c(100, 300)
  x.2 <- c(100, 200, 150)
  expect_equal(WeightedAverage(x.1, x.2, weight.1 = 1, weight.2 = 1),
               mean(c(x.1, x.2)))

  x.1 <- c(100)
  x.2 <- c(10)
  weight.1 <- 0.25
  weight.2 <- 0.75
  expect_equal(WeightedAverage(x.1, x.2, weight.1, weight.2),
               weight.1 * x.1 + weight.2 * x.2)
})

test_that("WeightedSE", {
  x.1 <- c(100, 300, 200)
  x.2 <- c(100, 200, 150)
  x <- c(x.1, x.2)
  expect_equal(WeightedSE(x.1, x.2, weight.1 = 10, weight.2 = 10),
               sd(x) / sqrt(length(x)))
})