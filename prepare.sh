#!/bin/bash

datasets=(
    'https://buyandsell.gc.ca/cds/public/contracts/tpsgc-pwgsc_co-ch_tous-all.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/ee1e9541-939d-429e-919a-8ab94527773c/download/comptagevelo2009.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/f23e1c88-cd04-467f-a64a-48f5eb1b6c9e/download/comptagevelo2010.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/f2e43419-ebb2-4e38-80b6-0644c8344338/download/comptagevelo2011.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/d54cec49-349e-47af-b152-7740056d7311/download/comptagevelo2012.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/ec12447d-6b2a-45d0-b0e7-fd69c382e368/download/comptagevelo2013.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/868b4bc8-ff55-4c48-ab3b-d80615445595/download/comptagevelo2014.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/64c26fd3-0bdf-45f8-92c6-715a9c852a7b/download/comptagevelo20152.csv'
    'http://donnees.ville.montreal.qc.ca/dataset/f170fecc-18db-44bc-b4fe-5b0b6d2c7297/resource/6caecdd0-e5ac-48c1-a0cc-5b537936d5f6/download/comptagevelo20162.csv'
)



for i in "${datasets[@]}"; do
    curl -L -o "data/$(basename ${i})" -C - "${i}"
done

exit 0
