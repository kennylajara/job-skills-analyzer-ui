<script context="module">
	/**
	 *
	 * TODO: Don't rush... use environment variable
	 *
	 */
	const API_URL = "http://localhost:3000/";
	// const API_URL = "https://api.skills.kennylajara.com/";
</script>

<script>
	let sample = 20;
	let skill = "Python";
	let market = "jobs";
	let proficiency = "master";

	let result = null;
	var related_skills = [];

	async function doPost() {
		const endpoint = `${API_URL}${market}?sample=${sample}`;
		const res = await fetch(endpoint, {
			method: "POST",
			body: JSON.stringify({
				skills: {
					[skill]: proficiency,
				},
			}),
			headers: {
				"Content-Type": "application/json",
			},
		});

		const json = await res.json();
		result = JSON.parse(JSON.stringify(json));
		related_skills = [];

		for (const key in result.related_skills) {
			// console.log(`${key} => ${result.related_skills[key]}`);
			alert(`${key} => ${result.related_skills[key]}`);
		}
	}
</script>

<main>
	<!-- 
	#
	#	TODO: DONT RUSH!!!! USE COMPONENTS
	#
	-->

	<!--Main Navigation-->
	<header>
		<style>
			#intro {
				background-image: url(https://mdbootstrap.com/img/new/fluid/city/008.jpg);
				height: 100vh;
			}

			/* Height for devices larger than 576px */
			@media (min-width: 992px) {
				#intro {
					margin-top: -58.59px;
				}
			}

			.navbar .nav-link {
				color: #fff !important;
			}
		</style>

		<!-- Navbar -->
		<nav
			class="navbar navbar-expand-lg navbar-dark d-none d-lg-block"
			style="z-index: 2000;"
		>
			<div class="container-fluid">
				<!-- Navbar brand -->
				<a
					class="navbar-brand nav-link"
					target="_blank"
					href="https://skills.kennylajara.com"
				>
					<strong>Skills</strong>
				</a>
				<button
					class="navbar-toggler"
					type="button"
					data-mdb-toggle="collapse"
					data-mdb-target="#navbarExample01"
					aria-controls="navbarExample01"
					aria-expanded="false"
					aria-label="Toggle navigation"
				>
					<i class="fas fa-bars" />
				</button>
				<div class="collapse navbar-collapse" id="navbarExample01">
					<ul class="navbar-nav me-auto mb-2 mb-lg-0">
						<li class="nav-item active">
							<a
								class="nav-link"
								href="#"
								rel="nofollow"
								target="_blank"
								>A market based job skill analyzer</a
							>
						</li>
					</ul>

					<ul class="navbar-nav d-flex flex-row">
						<!-- Icons -->
						<li class="nav-item me-3 me-lg-0">
							<a class="nav-link" href="#github-links">
								<i class="fab fa-github" />
							</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<!-- Navbar -->

		<!-- Background image -->
		<div id="intro" class="bg-image shadow-2-strong">
			<div
				class="mask d-flex align-items-center h-100"
				style="background-color: rgba(0, 0, 0, 0.8);"
			>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-xl-5 col-md-8">
							<form
								class="bg-white  rounded-5 shadow-5-strong p-5"
							>
								<p class="fs-5 text">
									Select the market you want to explore
								</p>
								<!-- Default radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="market"
										bind:group={market}
										id="flexRadioDefault1"
										value="jobs"
										checked
									/>
									<label
										class="form-check-label"
										for="flexRadioDefault1"
									>
										Job offer
									</label>
								</div>

								<!-- Default checked radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="market"
										bind:group={market}
										id="flexRadioDefault2"
										value="people"
									/>
									<label
										class="form-check-label"
										for="flexRadioDefault2"
									>
										Human talent
									</label>
								</div>

								<p class="fs-5 text mt-4">
									What skill are you looking for?
								</p>

								<div class="form-outline">
									<input
										type="text"
										id="form12"
										class="form-control"
										style="border: 1px solid #ddd;"
										placeholder="PHP"
										bind:value={skill}
									/>
								</div>

								<p class="fs-5 text mt-4">Proficiency</p>
								<!-- Default radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="proficiency"
										bind:group={proficiency}
										id="aflexRadioDefault1"
										value="master"
										checked
									/>
									<label
										class="form-check-label"
										for="aflexRadioDefault1"
									>
										Master
									</label>
								</div>

								<!-- Default checked radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="proficiency"
										bind:group={proficiency}
										id="aflexRadioDefault2"
										value="expert"
									/>
									<label
										class="form-check-label"
										for="aflexRadioDefault2"
									>
										Expert
									</label>
								</div>

								<!-- Default checked radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="proficiency"
										bind:group={proficiency}
										id="aflexRadioDefault3"
										value="proficient"
									/>
									<label
										class="form-check-label"
										for="aflexRadioDefault3"
									>
										Proficient
									</label>
								</div>

								<!-- Default checked radio -->
								<div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="proficiency"
										bind:group={proficiency}
										id="aflexRadioDefault4"
										value="novice"
									/>
									<label
										class="form-check-label"
										for="aflexRadioDefault4"
									>
										Novice
									</label>
								</div>

								<!-- Default checked radio -->
								<!-- <div class="form-check">
									<input
										class="form-check-input"
										type="radio"
										name="proficiency"
										bind:group={proficiency}
										id="aflexRadioDefault5"
										value="no_experience_interested"
									/>
									<label
										class="form-check-label"
										for="aflexRadioDefault5"
									>
										Interested
									</label>
								</div> -->

								<p class="fs-5 text mt-4">Sample Size</p>

								<div class="form-outline">
									<input
										type="text"
										id="form12"
										class="form-control"
										style="border: 1px solid #ddd;"
										bind:value={sample}
									/>
								</div>

								<button
									type="button"
									class="btn btn-primary btn-block mt-4"
									on:click={doPost}
								>
									Explore
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Background image -->
	</header>
	<!--Main Navigation-->

	<!--Footer-->
	<footer id="github-links" class="bg-light text-lg-start">
		<div class="py-4 text-center">
			<a
				role="button"
				class="btn btn-primary btn-lg m-2 text-white"
				href="https://github.com/kennylajara/job-skills-analyzer-ui"
				target="_blank"
			>
				Frontend Source Code
			</a>
			<a
				role="button"
				class="btn btn-primary btn-lg m-2 text-white"
				href="https://github.com/kennylajara/job-skills-analyzer"
				target="_blank"
			>
				Backend Source Code
			</a>
		</div>

		<hr class="m-0" />

		<!--
		<div class="text-center py-4 align-items-center">
			<p>Follow MDB on social media</p>
			<a
				href="https://www.youtube.com/channel/UC5CF7mLQZhvx8O5GODZAhdA"
				class="btn btn-primary m-1"
				role="button"
				rel="nofollow"
				target="_blank"
			>
				<i class="fab fa-youtube" />
			</a>
			<a
				href="https://www.facebook.com/mdbootstrap"
				class="btn btn-primary m-1"
				role="button"
				rel="nofollow"
				target="_blank"
			>
				<i class="fab fa-facebook-f" />
			</a>
			<a
				href="https://twitter.com/MDBootstrap"
				class="btn btn-primary m-1"
				role="button"
				rel="nofollow"
				target="_blank"
			>
				<i class="fab fa-twitter" />
			</a>
			<a
				href="https://github.com/mdbootstrap/mdb-ui-kit"
				class="btn btn-primary m-1"
				role="button"
				rel="nofollow"
				target="_blank"
			>
				<i class="fab fa-github" />
			</a>
		</div>
		-->

		<!-- Copyright -->
		<div
			class="text-center p-3"
			style="background-color: rgba(0, 0, 0, 0.2);"
		>
			© 2021 Copyright:
			<a class="text-dark" href="https://kennylajara.com/">Kenny Lajara</a
			>
		</div>
		<!-- Copyright -->
	</footer>
	<!--Footer-->

	<!-- Modal -->
	<div
		class="modal fade"
		id="myModal"
		tabindex="-1"
		aria-labelledby="exampleModalLabel"
		aria-hidden="true"
	>
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">
						Modal title
					</h5>
					<button
						type="button"
						class="btn-close"
						data-mdb-dismiss="modal"
						aria-label="Close"
					/>
				</div>
				<div class="modal-body">...</div>
				<div class="modal-footer">
					<button
						type="button"
						class="btn btn-secondary"
						data-mdb-dismiss="modal"
					>
						Close
					</button>
					<button type="button" class="btn btn-primary"
						>Save changes</button
					>
				</div>
			</div>
		</div>
	</div>
</main>

<style>
	main {
		padding: 0;
		margin: 0;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>
