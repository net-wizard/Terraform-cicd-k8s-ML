import pickle
import numpy as np

# ── Retail product catalogue ──────────────────────────────
products = [
    "Running Shoes", "Formal Shirt", "Wrist Watch",
    "Leather Bag",   "Sunglasses",   "Sports T-Shirt",
    "Denim Jeans",   "Sneakers",     "Backpack",
    "Casual Belt"
]

# ── Simulated users ───────────────────────────────────────
users = [f"U{str(i).zfill(3)}" for i in range(1, 21)]
# produces: ["U001", "U002", ..., "U020"]

# ── Simulated purchase matrix ─────────────────────────────
# Rows = users, Columns = products
# Value = purchase score (0.0 to 1.0)
# Higher score = stronger preference for that product
np.random.seed(42)   # fixed seed = same matrix every run
matrix = np.random.dirichlet(
    np.ones(len(products)), size=len(users)
)

# ── Save model ────────────────────────────────────────────
model_data = {
    "matrix":   matrix.tolist(),
    "products": products,
    "users":    users
}

with open("model.pkl", "wb") as f:
    pickle.dump(model_data, f)

print("✓ model.pkl created")
print(f"  Users:    {len(users)}")
print(f"  Products: {len(products)}")
print(f"  Matrix:   {matrix.shape}")
print(f"\nSample — top 5 for U001:")
user_vector = matrix[0]
top = sorted(range(len(user_vector)),
             key=lambda i: user_vector[i], reverse=True)[:5]
for rank, idx in enumerate(top, 1):
    print(f"  {rank}. {products[idx]} ({user_vector[idx]:.3f})")
