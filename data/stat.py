import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd

# Set style
plt.style.use('seaborn')
sns.set_palette("husl")

# Create sample data
gas_costs = {
    'Operation': ['Add Book Base', 'String Storage', 'Read Book', 'Update Book'],
    'Gas Cost': [50000, 2000, 25000, 35000],
    'Category': ['Write', 'Storage', 'Read', 'Write']
}

transaction_time = {
    'Operation': ['Add Book', 'Read Book', 'Search Book', 'Update Book'],
    'Time (seconds)': [2.5, 1.5, 1.0, 2.0]
}

# Create DataFrames
df_gas = pd.DataFrame(gas_costs)
df_time = pd.DataFrame(transaction_time)

# Create subplots
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# Plot 1: Gas Costs
sns.barplot(data=df_gas, x='Operation', y='Gas Cost', hue='Category', ax=ax1)
ax1.set_title('Gas Costs by Operation Type')
ax1.set_ylabel('Gas Cost (units)')
ax1.tick_params(axis='x', rotation=45)

# Plot 2: Transaction Time
sns.barplot(data=df_time, x='Operation', y='Time (seconds)', ax=ax2, color='skyblue')
ax2.set_title('Transaction Processing Time')
ax2.set_ylabel('Time (seconds)')
ax2.tick_params(axis='x', rotation=45)

# Add a line for average processing time
avg_time = df_time['Time (seconds)'].mean()
ax2.axhline(y=avg_time, color='red', linestyle='--', label=f'Average: {avg_time:.1f}s')
ax2.legend()

# Adjust layout
plt.tight_layout()

# Add overall title
fig.suptitle('BookChain System Performance Analysis', y=1.05, fontsize=14)

# Show plot
plt.show()

# Create scaling analysis data
book_counts = np.array([100, 1000, 5000, 10000])
storage_costs = book_counts * 0.0001  # Estimated ETH cost per book

# Create new figure for scaling analysis
plt.figure(figsize=(10, 6))

# Plot scaling costs
plt.plot(book_counts, storage_costs, marker='o', linewidth=2, markersize=8)
plt.fill_between(book_counts, storage_costs*0.8, storage_costs*1.2, alpha=0.2)

plt.title('Estimated Storage Cost Scaling')
plt.xlabel('Number of Books')
plt.ylabel('Estimated Cost (ETH)')
plt.grid(True)

# Add cost annotations
for i, (books, cost) in enumerate(zip(book_counts, storage_costs)):
    plt.annotate(f'{cost:.4f} ETH',
                (books, cost),
                textcoords="offset points",
                xytext=(0,10),
                ha='center')

plt.tight_layout()
plt.show()