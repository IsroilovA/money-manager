# Money Manager

Money Manager is a Flutter application designed to help you manage your finances efficiently. With this app, you can add multiple accounts (wallets), track your expenses and incomes, transfer money between accounts, and view simple statistics for a selected date range.

## Screenshots
<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="assets/screenshots/Screenshot_1716548580.png" alt="Screenshot 4" width="200">
  <img src="assets/screenshots/Screenshot_1716548633.png" alt="Screenshot 5" width="200">
  <img src="assets/screenshots/Screenshot_1716548641.png" alt="Screenshot 6" width="200">
  <img src="assets/screenshots/Screenshot_1716548669.png" alt="Screenshot 7" width="200">
  <img src="assets/screenshots/Screenshot_1716548680.png" alt="Screenshot 8" width="200">
  <img src="assets/screenshots/Screenshot_1716548775.png" alt="Screenshot 9" width="200">
  <img src="assets/screenshots/Screenshot_1716548781.png" alt="Screenshot 10" width="200">
  <img src="assets/screenshots/Screenshot_1716546010.png" alt="Screenshot 1" width="200">
  <img src="assets/screenshots/Screenshot_1716548486.png" alt="Screenshot 2" width="200">
  <img src="assets/screenshots/Screenshot_1716548790.png" alt="Screenshot 3" width="200">
</div>

## Core Features Implementation

### Local Database with `sqflite` package.
- The app stores all the information locally on the device only. This feature is implemented using a SQLite database managed with the `sqflite` package.

### Adding Multiple Accounts (Wallets)
- The app allows users to create multiple accounts, each representing a wallet.

### Tracking Transactions
- **Expense and Income Tracking:** Users can add expenses and incomes to their accounts. Each transaction is recorded in the database with relevant details such as amount, category, and timestamp.
- **Transfer:** Money transfer between accounts is facilitated by updating the balances of the sender and receiver accounts accordingly in the database.

### Viewing Simple Statistics
- **Implementation:** The app provides users with simple statistics for a selected date range. These statistics are generated using the data stored in the database and visualized using the `syncfusion_flutter_charts` package.

### State Management with Cubit
- **Implementation:** The app utilizes the Cubit pattern for state management. Each feature module, such as account management, transaction tracking, and statistics, has its own Cubit responsible for managing its state. This ensures a clean and organized codebase with clear separation of concerns.

## Development

The core features of Money Manager are implemented using Flutter and various packages to simplify development and enhance user experience.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any feature enhancements or bug fixes.

## Contact

For any inquiries, please contact [aisroilov1029@gmail.com](aisroilov1029gmail.com).