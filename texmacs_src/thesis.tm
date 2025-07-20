<TeXmacs|2.1.4>

<style|generic>

<\body>
  <doc-data|<doc-title|Machine-Learning Based Reduced Order Model for
  Nonlinear Nozzle Flows Reconstruction>|<doc-author|<author-name|Allan
  Moreira de Carvalho>>|<doc-abstract|This study presents a machine
  learning-based surrogate modeling framework for reconstructing steady-state
  two-dimensional nozzle flows under varying flow and geometric conditions.
  The approach enables accurate prediction of high-fidelity viscous fields
  using low-dimensional inputs, such as scalar boundary conditions or
  quasi-one-dimensional (Q1D) solutions. To mitigate the challenges of
  training on high-dimensional data, Proper Orthogonal Decomposition (POD) is
  employed for dimensionality reduction, retaining dominant flow features
  while significantly lowering computational cost. Two regression strategies
  were investigated: Artificial Neural Networks (ANNs) and Gaussian Processes
  (GPs). A custom loss function was introduced for ANN models, combining mean
  squared error in both latent and reconstructed physical spaces, promoting
  accurate full-field recovery. Hyperparameter tuning was performed using
  Bayesian Optimization with Hyperband (BOHB), revealing that shallow ANNs
  with activation functions such as <em|sigmoid>, <em|hard sigmoid>, and
  <em|swish> consistently yield optimal performance. Comprehensive evaluation
  across multiple datasets and boundary conditions demonstrated that ANNs
-  generally achieve higher coefficients of determination (<math|R<rsup|2>>),
  while GPs attain lower normalized root mean square error (NRMSE) under
  large, clean datasets. Robustness tests revealed that ANN models degrade
  more gracefully under input noise, whereas GPs are more sensitive but
  outperform ANNs when sufficient clean data are available. K-fold
  cross-validation confirmed the stability of ANNs in data-scarce regimes,
  and SHapley Additive exPlanations (SHAP) analysis provided physical insight
  by identifying the dominant influence of total pressure and the limited
  effect of wall temperature. This work provides valuable insights and
  practical guidelines for developing accurate and computationally efficient
  surrogate models in fluid dynamics.>>

  <\title*>
    <strong|<huge|Machine-Learning Based Reduced Order Model for Nonlinear
    Nozzle Flows Reconstruction>>
  </title*>

  <\author>
    <author-data>
      <author-name>
        Allan Moreira de Carvalho
      </author-name>
    </author-data>
  </author>

  <section|Abstract>

  This study presents a machine learning-based surrogate modeling framework
  for reconstructing steady-state two-dimensional nozzle flows under varying
  flow and geometric conditions. The approach enables accurate prediction of
  high-fidelity viscous fields using low-dimensional inputs, such as scalar
  boundary conditions or quasi-one-dimensional (Q1D) solutions. To mitigate
  the challenges of training on high-dimensional data, Proper Orthogonal
  Decomposition (POD) is employed for dimensionality reduction, retaining
  dominant flow features while significantly lowering computational cost. Two
  regression strategies were investigated: Artificial Neural Networks (ANNs)
  and Gaussian Processes (GPs). A custom loss function was introduced for ANN
  models, combining mean squared error in both latent and reconstructed
  physical spaces, promoting accurate full-field recovery. Hyperparameter
  tuning was performed using Bayesian Optimization with Hyperband (BOHB),
  revealing that shallow ANNs with activation functions such as <em|sigmoid>,
  <em|hard sigmoid>, and <em|swish> consistently yield optimal performance.
  Comprehensive evaluation across multiple datasets and boundary conditions
  demonstrated that ANNs generally achieve higher coefficients of
  determination (<math|R<rsup|2>>), while GPs attain lower normalized root
  mean square error (NRMSE) under large, clean datasets. Robustness tests
  revealed that ANN models degrade more gracefully under input noise, whereas
  GPs are more sensitive but outperform ANNs when sufficient clean data are

-  available. K-fold cross-validation confirmed the stability of ANNs in
  data-scarce regimes, and SHapley Additive exPlanations (SHAP) analysis
  provided physical insight by identifying the dominant influence of total
  pressure and the limited effect of wall temperature. This work provides
  valuable insights and practical guidelines for developing accurate and
  computationally efficient surrogate models in fluid dynamics.

  <section|Acknowledgements>

  We gratefully acknowledge the support of the RCGI---Research Centre for
  Greenhouse Gas Innovation, hosted by the University of São Paulo (USP) and
  sponsored by FAPESP---S\~ao Paulo Research Foundation (2014/50279-4 and
  2020/15230-5) and Shell Brasil, and the strategic importance of the support
  given by ANP (Brazil's National Oil, Natural Gas, and Biofuels Agency)
  through the R\&D levy regulation. Also, the support of the UFABC---Federal
  University of ABC, which provides all the computational and physical
  infrastructure.

  <\table-of-contents>
    <toc-chap|1|Introduction|1>
    <toc-sec|1.1|Motivation and Context|1>
    <toc-sec|1.2|Problem Statement and Objectives|1>
    <toc-sec|1.3|Thesis Contributions|2>
    <toc-sec|1.4|Thesis Outline|2>
    <toc-chap|2|Literature Review|3>
    <toc-sec|2.1|Introduction|3>
    <toc-sec|2.2|The Challenge of High-Fidelity Flow Simulation|3>
    <toc-sec|2.3|Machine Learning as a Solution in Fluid Dynamics|3>
    <toc-sec|2.4|Reduced-Order Modeling (ROMs)|4>
    <toc-ssec|2.4.1|Projection-Based ROMs and Proper Orthogonal Decomposition
    (POD)|4>
    <toc-sec|2.5|Data-Driven ROMs for Flow Field Reconstruction|4>
    <toc-ssec|2.5.1|Surrogate Models: Artificial Neural Networks and Gaussian
    Processes|5>
    <toc-sec|2.6|Research Gap and Thesis Contribution|5>
    <toc-chap|3|Nomenclature and Abbreviations|6>
  </table-of-contents>

  <chapter|Introduction>

  <section|Motivation and Context>

  Machine Learning (ML), a subfield of Artificial Intelligence, has emerged
  as a powerful paradigm for modeling complex physical phenomena where
  governing equations are either unknown or computationally difficult to
  solve, as is the case with turbulent compressible flows. In aerothermodynamic
  design and optimization, detailed knowledge of the flow field is essential,
  yet typically obtained from computationally expensive numerical
  simulations. This has motivated the development of surrogate models, which
  retain high accuracy while significantly reducing the computational cost.

  The performance of rocket engines is highly dependent on the flow expansion
  occurring in the divergent section of the nozzle, where complex phenomena
  such as shock wave--boundary layer interactions (SWBLI) strongly influence
  efficiency. Accurate prediction of these dynamics typically requires
  high-resolution Computational Fluid Dynamics (CFD) simulations. This work
  addresses the challenge of creating fast and accurate models for these
  complex flows.

  <section|Problem Statement and Objectives>

  This work proposes a data-driven framework for constructing and optimizing
  machine-learning-based reduced-order models (ML-ROMs) for flow field
  reconstruction. The objective is to build a parametric surrogate model
  capable of reconstructing the flow fields of a supersonic hot air stream
  within a convergent-divergent nozzle. The model must be able to accurately
  predict high-fidelity viscous fields from low-dimensional inputs, such as
  scalar boundary conditions or quasi-one-dimensional (Q1D) solutions.

  The main objectives are:

  <\itemize>
    <\item>
      To develop an ML-ROM framework to reconstruct 2D nozzle flow fields
      from low-dimensional inputs.
    </item>

    <\item>
      To investigate and compare two regression strategies: Artificial
      Neural Networks (ANNs) and Gaussian Processes (GPs).
    </item>

    <\item>
      To introduce and evaluate a novel loss function for ANNs that combines
      errors in the latent and physical spaces to improve reconstruction
      fidelity.
    </item>

    <\item>
      To perform a systematic hyperparameter optimization to find the most
      effective model architectures.
    </item>

    <\item>
      To rigorously evaluate the performance, robustness, interpretability,
      and computational efficiency of the developed models.
    </item>
  </itemize>

  <section|Thesis Contributions>

  The main contributions of this work are:

  <\itemize>
    <\item>
      A surrogate modeling framework that reconstructs 2D viscous nozzle
      flows from low-dimensional inputs using POD-based dimensionality
      reduction.
    </item>

    <\item>
      A comprehensive evaluation of Artificial Neural Networks (ANNs) and
      Gaussian Processes (GPs) with extensive hyperparameter tuning via BOHB.
    </item>

    <\item>
      A novel loss function that improves ANN performance by combining latent
      and physical-space reconstruction errors.
    </item>

    <\item>
      An in-depth analysis of model robustness to data variability (k-fold
      cross-validation) and input noise, showing the superiority of ANNs in
      non-ideal data scenarios.
    </item>

    <\item>
      The use of SHAP analysis to reveal the importance of input features,
      aligning with physical principles and supporting the interpretability of
      predictions.
    </item>

    <\item>
      The demonstration that surrogate models enable real-time inference,
      achieving speed-ups of up to 7374<math| \times |> compared to CFD
      solvers.
    </item>
  </itemize>

  <section|Thesis Outline>

  The remainder of this thesis is organized as follows:

  <\itemize>
    <\item>
      <strong|Chapter 2> presents the theoretical background, covering the
      governing equations of fluid dynamics, the nozzle flow modeling, and the
      theoretical basis for the machine learning methods used.
    </item>

    <\item>
      <strong|Chapter 3> details the methodology, including the setup of the
      numerical experiments, the generation of the datasets, and the complete
      ML-ROM architecture, from preprocessing to hyperparameter optimization.
    </item>

    <\item>
      <strong|Chapter 4> presents and discusses the results, focusing on
      model evaluation, robustness, interpretability, computational
      efficiency, and analysis of the flow field reconstructions.
    </item>

    <\item>
      <strong|Chapter 5> concludes the work, summarizing the key findings,
      discussing the limitations, and suggesting directions for future
      research.
    </item>
  </itemize>

  <chapter|Literature Review>

  <section|Introduction>

  This chapter provides a review of the relevant literature, establishing the
  context for the present work. It begins by outlining the computational
  challenges in modern fluid dynamics that motivate the development of
  surrogate models. It then surveys the application of Machine Learning (ML)
  to the field, with a specific focus on Reduced-Order Models (ROMs) for flow
  field reconstruction. The state-of-the-art concerning data-driven
  techniques, particularly those employing Artificial Neural Networks (ANNs)
  and Gaussian Processes (GPs), is discussed. Finally, this review identifies
  the specific gaps in the current body of knowledge that this thesis aims to
  address, thereby positioning its contributions within the broader
  scientific landscape.

  <section|The Challenge of High-Fidelity Flow Simulation>

  In modern aerothermodynamic design and optimization, a detailed
  understanding of the flow field is indispensable. Traditionally, this
  knowledge is acquired through high-fidelity numerical simulations, such as
  solving the Reynolds-Averaged Navier--Stokes (RANS) or Large Eddy
  Simulation (LES) equations. However, these simulations are often
  computationally expensive, sometimes prohibitively so, especially when
  numerous evaluations are required for design space exploration, uncertainty
  quantification, or optimization tasks. This computational bottleneck has
  spurred the development of surrogate models, which aim to preserve the high
  accuracy of detailed simulations while drastically reducing the
  computational cost.

  <section|Machine Learning as a Solution in Fluid Dynamics>

  Machine Learning (ML), a subfield of Artificial Intelligence, has emerged
  as a powerful paradigm for modeling complex physical phenomena where
  governing equations are either unknown or computationally difficult to
  solve, as is the case with turbulent compressible flows. As noted by
  researchers such as <cite|mendezChallenges2024>, <cite|Brunton2020>, and
  <cite|vinuesaEmerging2022>, ML has been successfully applied to a wide array
  of engineering problems. These applications include, but are not limited
  to:

  <\itemize>
    <\item>
      Pattern recognition <cite|bishopPattern2006, Groun2022, Salehi2018>
    </item>

    <\item>
      Classification tasks <cite|Wang2016>
    </item>

    <\item>
      Optimization and design <cite|Bock2019, ferreiraEnsemble2018,
      Kianifar2020, Peters2023>
    </item>

    <\item>
      Flow control <cite|Montans2019, talaeiBoundary2018>
    </item>

    <\item>
      Uncertainty quantification <cite|chuDeep2024, pengApplying2024,
      liangLiquid2024>
    </item>
  </itemize>

  Despite these successes, persistent challenges in the application of ML to
  physical systems remain, particularly concerning model selection,
  optimization, interpretability, and the generalization of models to unseen
  conditions.

  <section|Reduced-Order Modeling (ROMs)>

  Reduced-Order Models (ROMs) are a specific class of surrogate models
  designed to approximate the behavior of high-dimensional systems using a
  much smaller number of degrees of freedom. The fundamental goal of a ROM is
  to capture the most influential dynamics of the system, thereby enabling
  rapid and efficient predictions.

  <subsection|Projection-Based ROMs and Proper Orthogonal Decomposition
  (POD)>

  A cornerstone of many ROM strategies is Proper Orthogonal Decomposition
  (POD), a technique for data compression and feature extraction that is
  mathematically equivalent to Principal Component Analysis (PCA). As
  detailed by <cite|berkoozProper1993> and <cite|taira2017modal>, POD is used
  in fluid dynamics to identify a set of orthogonal basis functions, or
  ``modes,'' that capture the maximum possible kinetic energy for any given
  number of modes. These modes represent the dominant, large-scale coherent
  structures within the flow.

  By projecting the high-dimensional governing equations (e.g.,
  Navier-Stokes) onto a low-dimensional subspace spanned by a truncated set
  of these POD modes, one can create a computationally inexpensive
  projection-based ROM. However, these models can struggle with accurately
  capturing highly nonlinear phenomena or advection-dominated flows.

  <section|Data-Driven ROMs for Flow Field Reconstruction>

  An alternative and increasingly popular approach is the use of purely
  data-driven, or non-intrusive, ROMs. These methods learn the mapping
  between system parameters and the solution field directly from a database
  of high-fidelity simulation results. Recent studies have demonstrated the
  immense potential of ML to reconstruct high-dimensional flow fields from
  reduced or simplified input representations, especially given the
  availability of large CFD datasets <cite|Zhang2023, Erichson2020b,
  Deng2021, cahalyPLICNet2024, champenoisMachine2024,
  xuSelfsupervised2023>. This thesis follows this data-driven paradigm,
  creating a machine-learning-based reduced-order model (ML-ROM) for flow
  field reconstruction.

  <subsection|Surrogate Models: Artificial Neural Networks and Gaussian
  Processes>

  Within the data-driven framework, various regression algorithms can be
  employed as the core surrogate model. This work focuses on two of the most
  prominent techniques: Artificial Neural Networks (ANNs) and Gaussian
-  Processes (GPs).

  <\itemize>
    <\item>
      <strong|Artificial Neural Networks (ANNs)> are powerful function
      approximators inspired by the structure of the human brain. Their
      ability to model highly nonlinear relationships makes them well-suited
      for complex regression problems. They have been widely used in fluid
      dynamics for their universal approximation capabilities <cite|Berner2022,
      Czum2020, Kumar2020>.
    </item>

    <\item>
      <strong|Gaussian Processes (GPs)> are a nonparametric Bayesian method
      for regression. Instead of learning a single function, a GP learns a
      distribution over functions that are consistent with the training data.
      As described by <cite|rasmussenGaussian2006>, this provides a principled
      way to quantify prediction uncertainty, which is a significant advantage
      in many engineering applications <cite|Liu2020, Hasdiana2018a>.
    </item>
  </itemize>

  <section|Research Gap and Thesis Contribution>

  While the application of ML-ROMs for flow reconstruction is an active area
  of research, several gaps remain. Many existing studies focus on flows with
  simpler physics or do not perform a systematic optimization of the
  underlying ML model architecture and hyperparameters. Furthermore, rigorous
  analysis of model robustness to noisy data and a deep dive into the
  interpretability of the learned representations are often lacking.

  This thesis aims to fill these gaps by extending prior work, such as that by
  <cite|Yu2019>, to a more challenging physical problem. The focus is on a
  geometry-sensitive nozzle flow characterized by significant heat transfer
  and nonlinear shock formation, including complex shock wave--boundary layer
  interactions (SWBLI) as investigated by <cite|martelliFlow2020>. The
  specific contributions of this work, which address the identified gaps,
  are:

  <\enumerate>
    <item>A <strong|Novel Loss Function: To enhance model fidelity, a new
    loss function for ANNs is introduced, which combines reconstruction
    errors in both the latent (POD coefficient) space and the physical
    space.

    <item><strong|Systematic Hyperparameter Optimization:> The BOHB algorithm
    <cite|falknerBOHB2018> is employed to systematically and efficiently tune
    the surrogate models, moving beyond ad-hoc architecture selection.

    <item><strong|Comprehensive Robustness and Stability Analysis:> Model
    variance is assessed through k-fold cross-validation, and robustness is
    evaluated by injecting noise into the input data and analyzing the
    model's response.

    <item><strong|Physics-Based Interpretability:> SHAP analysis
    <cite|lundberg2017unified> is incorporated to understand the influence of
    input features on model predictions, providing physical insights into the
    learned representations and building trust in the surrogate model's
    predictions.
  </enumerate>

  By addressing these points, this research provides a comprehensive
  framework and practical guidelines for developing accurate, efficient, and
  reliable surrogate models for complex fluid dynamics problems.

  <chapter|Nomenclature and Abbreviations>

  <\table>
    <tformat|<cwith|1|1|1|1|cell-background|#EFEFEF>|<cwith|2|1|1|1|cell-align|l>|<cwith|3|1|1|1|cell-align|l>|<cwith|4|1|1|1|cell-align|l>|<cwith|5|1|1|1|cell-align|l>>
    <\trow>
      <tcell|<strong|Symbol>>

      <tcell|<strong|Description>>
    </trow>

    <\trow>
      <tcell|<math|A>>

      <tcell|Nozzle crossectional area>
    </trow>

    <\trow>
      <tcell|<math|<math-bf|b>>>

      <tcell|ANN bias vector>
    </trow>

    <\trow>
      <tcell|<math|<math-bf|C>>>

      <tcell|Covariance matrix>
    </trow>

    <\trow>
      <tcell|<math|<mathcal|D>>>

      <tcell|Dataset>
    </trow>

    <\trow>
      <tcell|<math|E>>

      <tcell|Total energy>
    </trow>

    <\trow>
      <tcell|<math|e>>

      <tcell|Specific total energy>
    </trow>

    <\trow>
      <tcell|<math|<math-bf|F>>>

      <tcell|Flux terms>
    </trow>
  </table>
</body>
