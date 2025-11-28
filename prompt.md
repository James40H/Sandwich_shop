Goal
Implement cart-item modification UX and logic so users can change quantity or remove/edit items from the cart. Integrate with the existing models (Sandwich, Cart) and Pricing repository. Enforce business rules (maxQuantity = 5, minQuantity = 1). Provide undo support and update totals immediately.

Context to give the LLM
- Project root: c:\Sandwich_shop
- Relevant files: lib/main.dart, lib/views/order_screen.dart, lib/views/cart_screen.dart (may not exist yet), lib/models/sandwich.dart, lib/models/cart.dart, lib/repositories/pricing.dart
- Current models: Sandwich (type, size, bread), Cart (add/remove/clear, total price)
- Pricing repo: calculates price per sandwich based on size and quantity. Price does NOT depend on sandwich type or bread.
- UI constraint: OrderScreen currently passes maxQuantity: 5.

Requested features (each feature: description + what should happen when the user performs the action)

1) Change quantity via stepper (increment/decrement)
- Description: Add + / − buttons (or Stepper) for each cart row to increase/decrease item quantity.
- On action:
  - User taps +: if current quantity < maxQuantity, increment quantity, recalc item price via Pricing, update Cart.total, persist cart state, update UI immediately.
  - If increment would exceed maxQuantity, show a small inline message or disable + button.
  - User taps −: if current quantity > 1, decrement quantity, recalc price and totals. If quantity would become 0, treat it as removal only if user confirms or if business rule allows 0 -> remove (prefer minQuantity = 1 to avoid accidental removals).
  - Emit analytics event (optional).
- Edge cases: concurrent edits should be handled by sequential state updates; UI must reflect loading/disabled state if async pricing is used.

2) Edit quantity via numeric input
- Description: Allow tapping the quantity label to open a small number input (keyboard) to set exact quantity.
- On action:
  - Validate integer input between 1 and maxQuantity.
  - If user inputs > maxQuantity, clamp to maxQuantity and show validation message.
  - Update Cart item quantity, recalc price via Pricing, update totals and UI.
  - On invalid input, restore previous valid quantity.

3) Remove item (delete)
- Description: Provide swipe-to-delete on cart rows and an explicit trash/delete icon.
- On action:
  - User swipes left/right or taps delete icon: remove the item from Cart, recalc totals, update UI.
  - Show a Snackbar with "Item removed" and an Undo action for at least ~3–5 seconds. Undo restores the removed item (quantity and sandwich options) and recalculates totals.
  - If user confirms a long-press "Remove all of this type" or taps a "Remove" confirmation dialog (optional), remove immediately.
- Edge cases: If removing an item merged from editing (see merge rules), ensure Undo restores previous merged state.

4) Edit item details (type, size, bread)
- Description: Allow the user to edit a cart item by tapping it to open an edit modal/screen pre-filled with the sandwich options. They can change type, size, bread, and quantity.
- On action:
  - User opens editor, modifies fields, taps Save.
  - If only the size changes, fetch new price via Pricing and update item price and Cart.total.
  - After Save:
    - If the edited sandwich becomes identical (same type, size, bread) to another existing cart row, merge quantities: newQuantity = min(existingQuantity + editedQuantity, maxQuantity). If the sum exceeds maxQuantity, leave remainder in edited item or show a prompt to split — recommended behavior: cap merged quantity to maxQuantity and create a separate item for the remainder (or show message asking user to reduce quantity).
    - If not identical to any existing item, update the item in-place.
  - Recalculate total and update UI.
  - Provide Undo for the edit action (restore previous item state for a short time).

5) Bulk actions
- Description: Allow "Clear cart" and "Remove all of type" from cart screen.
- On action:
  - Clear cart: show confirmation dialog, then clear Cart, update UI, show Undo snackbar that restores previous cart state.
  - Remove all of type: remove all items matching the criteria, show Undo.

6) Consistency & persistence
- Description: All changes must be reflected in the Cart model and persisted if the app persists cart state (shared prefs/local DB).
- On action:
  - After any modification, update the Cart repository/state manager and persist asynchronously. UI updates immediately; persistence happens in background. On persistence failure, surface a retry/error notification but keep UI consistent.

7) Pricing & total recalculation rules
- Description: Use the Pricing repository to compute item price after any quantity or size change. Pricing may accept (size, quantity) and return per-item price or line price.
- On action:
  - On quantity or size change, call Pricing to get new per-item price (or total line price) and update Cart.total.
  - Ensure sum(total of lines) equals Cart.total; include rounding rules (e.g., cents) in spec for LLM.

8) UX and accessibility
- Description: Buttons must be accessible (tap targets), support keyboard entry for quantity, and be usable with screen readers.
- On action:
  - Announce changes to accessibility services: "Quantity changed to X. Cart total is $Y."

Suggested API/implementation tasks for the LLM
- Add/extend Cart methods:
  - updateQuantity(itemId, newQuantity) -> validates, applies clamp, recalculates totals, returns previous state for undo.
  - removeItem(itemId) -> returns removed item for Undo.
  - editItem(itemId, Sandwich newSandwich, {newQuantity}) -> handles merging logic and returns prior state for Undo.
  - mergeIfNeeded(targetItemId, editedItem) -> merges with existing identical item(s) up to maxQuantity.
- UI tasks:
  - Implement CartScreen with rows showing sandwich summary, quantity controls, line price, and delete action.
  - Implement EditCartItem screen/modal pre-filled from Sandwich.
  - Add Undo Snackbars for delete/edit/clear actions.
- Tests:
  - Unit tests for Cart.updateQuantity, removeItem, editItem, and merge behavior.
  - Integration tests for CartScreen user flows: increment/decrement, delete+undo, edit+merge.
  - Pricing interactions: verify cart totals update according to Pricing calculations.

Acceptance criteria (how to know it's done)
- Users can change quantity using stepper and by editing the number; quantity always between 1 and maxQuantity.
- Users can remove items by swipe or delete icon; Undo is available and restores previous state.
- Users can edit sandwich options; edits recalc prices; identical items merge logically without exceeding maxQuantity, with clear messaging or split behavior.
- Cart.total updates immediately and matches the sum of line prices (rounded consistently).
- Unit tests cover updateQuantity, removeItem, editItem/mergeEdgeCases and pass.
- UI is responsive and accessible (buttons have labels, disabled states for + when at max).

Extra notes for the LLM-to-be-asked
- Show example method signatures and small code snippets for Cart methods and calling Pricing.
- Provide unit test examples (Dart + flutter_test) for critical logic.
- When merging would overflow maxQuantity, prefer capping merged item at maxQuantity and creating a separate cart item for the remainder; document this behavior and ask if the user prefers a different approach.

Deliverable format requested from the LLM you will call
- A set of modified/added Dart files (Cart model changes, CartScreen UI, EditCartItem modal) with clear file paths.
- Unit tests for cart behavior (file paths).
- A short description of the merge rules implemented and why.
- Example screenshots/Widget test expectations (optional).

End of prompt.