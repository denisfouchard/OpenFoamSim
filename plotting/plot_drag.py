import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from typing import Iterable
import os

A_values = {
    "baseline": 0.0128,
    "v1": 0.0120764,
    "hole": 0.0105861,
    "shark": 0.0120764,
    "droplet": 0.0127684,
}


def read_data(filename: str):
    data: pd.DataFrame = pd.read_csv(
        filename,
        delim_whitespace=True,  # Handles the spacing between columns
        comment="#",  # Ignores lines starting with '#'
        header=None,  # No header in the data
        names=[
            "Time",
            "total_x",
            "total_y",
            "total_z",
            "pressure_x",
            "pressure_y",
            "pressure_z",
            "viscous_x",
            "viscous_y",
            "viscous_z",
        ],  # Assign meaningful column names
    )
    data = data.apply(pd.to_numeric, errors="coerce")
    return data


def drag_coeff(
    F_total: Iterable[float], rho: float, U_speed: float, S_area: float
) -> Iterable[float]:
    """
    Calculate the drag coefficient from the sum of forces in the x-direction.

    Parameters
    ----------
    force_sum : Iterable[float]
        Sum of forces in the x-direction.
    rho : float
        Density of the fluid.
    U_speed : float
        Speed of the fluid.
    area : float
        Area of the object.

    Returns
    -------
    Iterable[float]
        Drag coefficient.
    """
    return 2 * F_total / (rho * U_speed**2 * S_area)


def plot_drag_coefficients(
    A_values: dict[str, float],
    force_drag_list: list[Iterable[float]],
    rho: float = 1.225,
    U_speed: float = 14.0,
):
    """
    Plots drag coefficients for multiple time series.

    Parameters:
    - time_series_list: List of time series data
    - force_drag_list: List of force drag data
    - baseline_drag_list: List of baseline drag data
    - rho: Air density
    - U_speed: Speed
    - A_list: List of areas for each AhmedBetter
    - A_baseline_list: List of baseline areas for each AhmedBetter
    """
    plt.figure(figsize=(10, 6))

    for i, (name, A) in enumerate(A_values.items()):
        force_drag = np.abs(force_drag_list[i])[300:500]
        time = np.arange(len(force_drag))
        cd = drag_coeff(force_drag, rho, U_speed, A)
        mean_cd = np.mean(cd)
        median_cd = np.median(cd)

        plt.plot(time, cd, label=f"AhmedBetter{name.capitalize()}")
        plt.axhline(
            mean_cd,
            color="red",
            linestyle="--",
            # label=f"AhmedBetter {name} Mean Cd = {mean_cd:.2f}",
        )
        plt.axhline(
            median_cd,
            color="green",
            linestyle="--",
            # label=f"AhmedBetter {name} Median Cd = {median_cd:.2f}",
        )

    plt.xlabel("Steps")
    plt.ylabel("Drag Coefficient [-]")
    plt.title("Drag Coefficient vs Time")
    plt.legend()
    plt.grid()
    plt.show()


def main():
    # Read the data
    # get the .dat files from the current directory
    files = [f"force_{v}.dat" for v in A_values.keys()]

    for file in files:
        if not os.path.exists(file):
            raise FileNotFoundError(f"File {file} not found.")
    force_drag_list = [read_data(file)["total_x"] for file in files]
    plot_drag_coefficients(A_values, force_drag_list)


if __name__ == "__main__":
    main()
