<script>
	import Form from "./Form.svelte";
	import NavBar from "./layout/NavBar.svelte";
	import Footer from "./layout/Footer.svelte";
</script>

<main>
	<!--Main Navigation-->
	<header>
		<NavBar />

		<!-- Background image -->
		<div id="intro" class="bg-image shadow-2-strong">
			<div
				class="mask d-flex align-items-center h-100"
				style="background-color: rgba(0, 0, 0, 0.8);"
			>
				<Form />
			</div>
		</div>
		<!-- Background image -->
	</header>
	<!--Main Navigation-->

	<Footer />
</main>

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
