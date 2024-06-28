# HJ Hybrid Reachability

Code implementation of the work presented in [Hamilton-Jacobi Reachability Analysis for Hybrid Systems with Controlled and Forced Transitions](https://arxiv.org/abs/2309.10893)

## Getting Started

### Dependencies

* Matlab
* HelperOC by the HJ Reachability Group (https://github.com/HJReachability/helperOC)
* Level Set Methods Toolbox by Ian Mitchell (https://www.cs.ubc.ca/~mitchell/ToolboxLS/).

### Installing

* Clone the repo and add contents to your Matlab path.

### Executing program

* To test proper functionality, run \hj_hybrid_reachability\02_dog1D\brt_dog1D.m example file
* Expected result is the following value function:
  
    ![image](https://github.com/JavierBorquez/hj_hybrid_reachability/assets/88214391/7777f242-3454-4e81-b3a9-140be33428d0)
* Details on interpreting this plot can be found in section VII of the paper.

### Details on implementation  (PRELIMINARY V0.1)

* The main result is implemented in the function HJIPDE_hybrid_sys_solve(), which expands upon the HJIPDE_solve at the core of HelperOC.
* This implementation requires a dynamic system class definition for each distinct operation mode of the hybrid system, e.g. (@Dog1D_q1,@Dog1D_q2,@Dog1D_q3) for the walking, crouching, and frozen modes in the dog1D example.
* Additionally, the transition conditions and reset maps between modes must be specified, e.g., dog1D_transition_q12(), dog1D_transition_q13(), and dog1D_transition_q21() for the previously created modes.
* Finally, the connection between modes is specified directly on HJIPDE_hybrid_sys_solve(), for the dog1D example, this is specified by using compMethod='minDog1D'; this can be seen in line 1091 for how to get the BRT for each mode and in line 1155 for how the value is compared between modes. We acknowledge this last step is quite clunky, and we are working on a general way to pass this connection structure to HJIPDE_hybrid_sys_solve() without directly modifying the base function.
