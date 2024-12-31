import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def analyze_book_volumes():
    # Create the dataset
    data = {
        'volume': ['100', '1,000', '10,000', '100,000'],
        'gasPerBook': [50000, 52000, 55000, 58000],
        'totalGas': [5000000, 52000000, 550000000, 5800000000],
        'estimatedCostETH': [0.15, 1.56, 16.5, 174],
        'estimatedCostUSD': [375, 3900, 41250, 435000],
        'storageKB': [15, 150, 1500, 15000],
        'avgQueryTime': ['0.5', '0.8', '1.2', '2.5'],
        'networkLoad': ['Low', 'Medium', 'High', 'Very High']
    }
    
    # Convert to DataFrame
    df = pd.DataFrame(data)
    
    # Create figure with more height to accommodate spacing
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 12), height_ratios=[1, 1.2])
    
    # Plot 1: Gas per Book and Total Cost
    ax1.plot(df['volume'], df['gasPerBook'], marker='o', label='Gas Per Book', color='blue')
    ax1_twin = ax1.twinx()
    ax1_twin.plot(df['volume'], df['estimatedCostUSD'], marker='s', label='Total Cost (USD)', color='green')
    
    ax1.set_xlabel('Number of Books')
    ax1.set_ylabel('Gas Per Book (Wei)')
    ax1_twin.set_ylabel('Total Cost (USD)')
    ax1.set_title('Book Volume Analysis: Cost and Performance Metrics')
    
    # Combine legends
    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax1_twin.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2, loc='upper left')
    
    # Add more space between plots
    plt.subplots_adjust(hspace=0.4)
    
    # Plot 2: Create a heatmap of performance metrics
    performance_data = df[['volume', 'avgQueryTime', 'storageKB', 'networkLoad']].copy()
    performance_data['avgQueryTime'] = performance_data['avgQueryTime'].astype(float)
    
    # Create heatmap data
    heatmap_data = performance_data.set_index('volume')[['avgQueryTime', 'storageKB']]
    
    # Normalize the data for better visualization
    heatmap_data_normalized = (heatmap_data - heatmap_data.min()) / (heatmap_data.max() - heatmap_data.min())
    
    sns.heatmap(heatmap_data_normalized.T, 
                ax=ax2,
                cmap='YlOrRd',
                annot=heatmap_data.T,
                fmt='.2f',
                cbar_kws={'label': 'Normalized Values'})
    
    ax2.set_title('Performance Metrics by Volume', pad=20)
    
    # Adjust layout to prevent overlapping
    plt.tight_layout(pad=10.0)
    
    # Add space before printing text
    print("\n\n")
    print("Book Volume Analysis Summary:")
    print("=" * 100)
    print(df.to_string(index=False))
    
    print("\n\nNotes:")
    print("* Estimates based on ETH price = $2,500 USD")
    print("* Gas price calculated at average 30 Gwei")
    print("* Query times may vary depending on network load")
    print("\n")
    
    return df

if __name__ == "__main__":
    df = analyze_book_volumes()
    plt.show()