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
    import { Modal } from "mdb-ui-kit";

    let sample = 20;
    let skill = "Python";
    let market = "jobs";
    let proficiency = "master";

    let result = null;
    var related_skills = [];

    var modal = null;

    let getRandomTone = () => {
        let min = 64;
        let max = 128;
        return Math.floor(Math.random() * (max - min)) + min;
    };

    /**
     * Sumbit form
     */
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

        let iDiv = document.getElementById("modal-body");
        iDiv.innerHTML = "";
        for (const key in result.related_skills) {
            let innerDiv = document.createElement("span");
            innerDiv.style.color = "#ffffff";
            innerDiv.style.backgroundColor = `rgb(${getRandomTone()}, ${getRandomTone()}, ${getRandomTone()})`;
            innerDiv.style.margin = "5px";
            innerDiv.style.padding = "5px";
            innerDiv.style.borderRadius = "5px";
            innerDiv.style.display = "inline-block";
            let percentage = (result.related_skills[key] * 100).toFixed(2);
            innerDiv.innerHTML = `<strong>${key}:</strong> ${percentage}%`;
            iDiv.appendChild(innerDiv);
        }

        modal.show();
    }

    /**
     * Modal window
     */
    window.addEventListener(
        "DOMContentLoaded",
        (event) => {
            const selector = "#myModal";
            const modalElement = document.querySelector(selector);

            if (!modalElement) {
                return;
            }

            const mode = modalElement.dataset.autoOpen;
            const fade = modalElement.classList.contains("fade");

            if (fade && mode === "instant") {
                modalElement.classList.remove("fade");
            }

            modal = new Modal(modalElement, {});

            if (fade && mode === "instant") {
                // There's currently a bug in the backdrop when the fade class
                // will be added directly after the modal was opened to have the
                // close animation
                // modalElement.addEventListener('shown.bs.modal', function (event) {
                modalElement.addEventListener(
                    "hidden.bs.modal",
                    function (event) {
                        modalElement.classList.add("fade");
                    },
                    { once: true }
                );
            }
        },
        { once: true }
    );
</script>

<!-- Form -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-5 col-md-8">
            <form class="bg-white  rounded-5 shadow-5-strong p-5">
                <p class="fs-5 text">Select the market you want to explore</p>
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
                    <label class="form-check-label" for="flexRadioDefault1">
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
                    <label class="form-check-label" for="flexRadioDefault2">
                        Human talent
                    </label>
                </div>

                <p class="fs-5 text mt-4">What skill are you looking for?</p>

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
                    <label class="form-check-label" for="aflexRadioDefault1">
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
                    <label class="form-check-label" for="aflexRadioDefault2">
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
                    <label class="form-check-label" for="aflexRadioDefault3">
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
                    <label class="form-check-label" for="aflexRadioDefault4">
                        Novice
                    </label>
                </div>

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

<!-- Modal -->
<div
    class="modal fade"
    id="myModal"
    tabindex="-1"
    aria-labelledby="exampleModalLabel"
    aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-scrollable ">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Results</h5>
                <button
                    type="button"
                    class="btn-close"
                    data-mdb-dismiss="modal"
                    aria-label="Close"
                />
            </div>
            <div id="modal-body" class="modal-body">
                <span class="skill-tag">Placeholder</span>
            </div>
            <div class="modal-footer">
                <button
                    type="button"
                    class="btn btn-primary"
                    data-mdb-dismiss="modal"
                >
                    Close
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .skill-tag {
        background-color: #ff0000;
    }
</style>
