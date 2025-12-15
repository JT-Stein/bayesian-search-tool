# bayesian-search-tool
Implemented Bayesian search to find lost items including a heat map to visualize location probabilities in R

## Approach
Let $$m$$ be a $$5x5$$ matrix where the total sum of the elements of the matrix is equal to 1:

$$\sum_{i=1}^5\sum_{j=1}^5 m_{ij} = 1$$

Therefore, $$m$$ can be thought of as a probability mass function where the probability of finding the desired object in sector $$(i,j)$$ is equal to the value in the matrix, $$m_{ij}$$.

Once the user has input which sector was search and the object was not found, each sector's updated probability, $$P(contains the object)'$$, according to the following formula:

#### The sector is the sector being searched:

$$P(contains the object)' = P(contains the object)\frac{1-P(detection)}{}1 - P(contains the object) \times P(detection)$$

#### The sector is not the sector being searched:
