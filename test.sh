#!/bin/sh

terraform plan -out tf.plan && terraform show -json tf.plan > tf.plan.json && conftest test tf.plan.json