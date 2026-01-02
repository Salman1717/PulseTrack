# PulseTrack

PulseTrack is **not a product app**. It is an **architecture and concurrency demonstration project** built to showcase *how I structure modern SwiftUI applications* using **MVVM, async/await, task cancellation, actor isolation, and clean state management**.

This repository is meant to be **read**, **understood**, and **discussed in interviews**.

---

## 🎯 Purpose of This Project

This project exists to demonstrate:

* How I design **SwiftUI + MVVM architecture**
* How I handle **async/await and concurrency correctly**
* How I avoid **retain cycles and race conditions**
* How I separate **UI, business logic, and data safety**

> Think of this as an **architecture walkthrough**, not a feature-heavy app.

---

## 🧱 High-Level Architecture

```
SwiftUI View
    ↓ (binds to)
ViewModel (@MainActor)
    ↓ (calls)
Async Services (Protocols)
    ↓ (stores data safely)
Actor (MetricStore)
```

Each layer has **one responsibility** and communicates in a **single direction**.

---

## 📁 Project Structure

```
PulseTrack
│
├── Models
│   ├── Metric.swift
│   ├── HeartRate.swift
│   └── Steps.swift
│
├── Services
│   ├── MetricServiceProtocol.swift
│   ├── HeartRateService.swift
│   └── StepsService.swift
│
├── Actors
│   └── MetricStore.swift
│
├── ViewModels
│   └── DashboardViewModel.swift
│
├── Views
│   └── DashboardView.swift
│
└── Utilities
    └── AppError.swift
```

This structure mirrors how **real production SwiftUI apps** are organized.

---

## 🧩 Models

### `Metric` Protocol

Models conform to a protocol instead of being used directly.

**Why?**

* Keeps UI decoupled from concrete data types
* Allows adding new metrics without touching UI code

```swift
protocol Metric {
    var id: UUID { get }
    var name: String { get }
    var value: String { get }
}
```

Concrete models like `HeartRate` and `Steps` are implemented as **structs** for:

* Value semantics
* Thread safety
* No ARC overhead

---

## ⚡ Services (Async Data Sources)

Services are responsible for **fetching data asynchronously**.

They conform to a protocol:

```swift
protocol MetricServiceProtocol {
    func fetchMetric() async throws -> Metric
}
```

**Why this matters:**

* Enables dependency injection
* Makes the ViewModel testable
* Allows swapping real vs mock data sources

All services use **async/await** and never block the main thread.

---

## 🧠 ViewModel (MVVM + Concurrency)

The `DashboardViewModel` is the **core of the architecture**.

### Key characteristics:

* Annotated with `@MainActor`
* Owns UI state (`metrics`, `isLoading`, `error`)
* Starts and cancels async tasks
* Does **no UI work**

### Why `@MainActor`?

> UI state must always be updated on the main thread.

This guarantees safety without manual dispatching.

---

## 🔄 Async Work & Task Cancellation

Async work is performed using `Task {}` and tracked explicitly:

```swift
private var loadTask: Task<Void, Never>?
```

Before starting new work:

* Any existing task is cancelled

When the view disappears:

* The task is cancelled

**Why this matters:**

* Prevents wasted work
* Avoids updating UI for inactive views
* Demonstrates correct async lifecycle handling

---

## 🛡 Actor-Based Data Safety

Shared metric state is protected using an **actor**:

```swift
actor MetricStore {
    private var metrics: [Metric] = []
}
```

### Why use an actor?

* Eliminates data races
* No manual locking
* Fully compatible with async/await

The ViewModel:

* Writes to the actor
* Reads from the actor
* Updates UI on `@MainActor`

This separation keeps concurrency **safe and explicit**.

---

## ❗ Error Handling & Retry

Errors are modeled using a typed enum:

```swift
enum AppError: LocalizedError {
    case failedToLoad
}
```

The ViewModel exposes error state.
The View reacts declaratively:

* Shows error message
* Provides retry action

**No error logic lives in the View.**

---

## 🎨 SwiftUI View Philosophy

The View:

* Observes state
* Displays loading / error / success
* Forwards user actions

It contains **zero business logic**.

This makes the UI:

* Easy to reason about
* Easy to replace
* Easy to test indirectly

---

## 🧪 Testing (XCTest + Async/Await)

This project is intentionally structured to support **unit testing with XCTest**, focusing on **ViewModel-level tests** rather than UI tests.

### What is tested

* Async data loading logic
* Loading and error state transitions
* Retry behavior
* Concurrency correctness

### How async testing is handled

* Tests use `async` test functions supported by XCTest
* Dependencies are injected via protocols
* Mock services simulate success and failure cases

```swift
func testLoadMetricsSuccess() async {
    let viewModel = DashboardViewModel(
        heartRateService: MockMetricService(result: .success(HeartRate(bpm: 72))),
        stepsService: MockMetricService(result: .success(Steps(count: 5000)))
    )

    viewModel.loadMetrics()
    try? await Task.sleep(nanoseconds: 200_000_000)

    XCTAssertEqual(viewModel.metrics.count, 2)
    XCTAssertNil(viewModel.error)
}
```

### Why XCTest (and not UI tests)

* ViewModels contain business logic
* SwiftUI views are declarative and thin
* Unit tests are faster, more reliable, and easier to maintain

This approach mirrors **real production testing strategies** used in modern SwiftUI apps.

---


## 📌 Why This Project Exists in My Portfolio

* Shows **how I think**, not just what I build
* Demonstrates **modern Swift concurrency**
* Highlights **clean separation of concerns**
* Easy for reviewers to scan and discuss

---

## 👨‍💻 Author

**Salman Mhaskar**

---

> This repository is intentionally simple in UI and rich in structure.
> The goal is clarity, correctness, and explainability.
