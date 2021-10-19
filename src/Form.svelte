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

    let sample = 1000;
    var skill = "";
    let proficiency = "master";
    var market = "people";

    let result = null;

    var modal = {};

    let getFreqColor = (percentil) => {
        if (percentil >= 80) {
            return "green";
        } else if (percentil >= 60) {
            return "blue";
        } else if (percentil >= 40) {
            return "yellow";
        } else if (percentil >= 20) {
            return "orange";
        } else {
            return "red";
        }
    };

    /**
     * Print Related Skills
     */
    function printRelatedSkills(market, percentils) {
        let iDiv = document.getElementById(`modal-tags-${market}`);
        iDiv.innerHTML = "";

        // Rewuired vars to limit the number of low priority skills
        let found_red_skill = false;
        let skills_counter = 0;
        let related_skills_to_show = 0;

        for (const key in percentils) {
            // Initialization
            let percentil = percentils[key];
            let color = percentil >= 20 && percentil < 60 ? "#222" : "#fff";
            let innerDiv = document.createElement("span");

            // Limit low priority skills
            if (percentil < 20) {
                if (found_red_skill == false) {
                    found_red_skill = true;
                    related_skills_to_show = Math.ceil(
                        Number(skills_counter) / 4
                    );
                } else {
                    related_skills_to_show--;
                }
            }
            skills_counter++;

            // Print the tag
            innerDiv.style.color = color;
            innerDiv.style.backgroundColor = getFreqColor(percentil);
            innerDiv.style.margin = "5px";
            innerDiv.style.padding = "5px";
            innerDiv.style.borderRadius = "5px";
            innerDiv.style.display = "inline-block";
            innerDiv.innerHTML = `<strong>${key}</strong>`;

            console.log(key);
            console.log(percentil);
            console.log(related_skills_to_show);

            if (percentil < 20 && related_skills_to_show == 0) {
                break;
            }
            iDiv.appendChild(innerDiv);
        }
    }

    /**
     * Sumbit form
     */
    async function submitForm() {
        if (skill) {
            if (market == "people") {
                document.getElementById("skill_is_required").style.display =
                    "none";
                let skills = await exploreMarket(market, false);
                printRelatedSkills(market, skills);
                modal[market].show();
            } else {
                // Skills from market `people`
                document.getElementById("skill_is_required").style.display =
                    "none";
                let peopleSkills = await exploreMarket("people", false);

                // Skills from market `job`
                document.getElementById("skill_is_required").style.display =
                    "none";
                let jobSkills = await exploreMarket("jobs", false);

                // Find common skills
                let jobSkillsList = Object.keys(jobSkills);
                let relevantSkills = {};
                for (var key in peopleSkills) {
                    if (jobSkillsList.includes(key)) {
                        relevantSkills[key] =
                            jobSkills[key] * (1 / peopleSkills[key]);
                    }
                }

                // Convert to percentil
                let max_skill_frequency = Math.max.apply(
                    null,
                    Object.values(result.related_skills)
                );
                let percentils = {};
                for (const key in result.related_skills) {
                    percentils[key] =
                        (result.related_skills[key] / max_skill_frequency) *
                        100;
                }

                printRelatedSkills(market, percentils);
                modal["jobs"].show();
            }
        } else {
            document.getElementById("skill_is_required").style.display =
                "block";
        }
    }

    /**
     * Explore market
     * @param market
     */
    async function exploreMarket(market) {
        document.body.style.cursor = "wait";
        document.getElementById("btn_explore").disabled = true;

        if (Number(sample) <= 2500) {
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

            let max_skill_frequency = Math.max.apply(
                null,
                Object.values(result.related_skills)
            );

            let percentils = {};
            for (const key in result.related_skills) {
                percentils[key] =
                    (result.related_skills[key] / max_skill_frequency) * 100;
            }

            document.body.style.cursor = "auto";
            document.getElementById("btn_explore").disabled = false;

            return percentils;
        } else {
            let iDiv = document.getElementById(`modal-body-${market}`);
            iDiv.innerHTML = "The maximun sample size is 2,500.";
        }
    }

    /**
     * Modal window
     */
    ["jobs", "people"].forEach((market) => {
        window.addEventListener(
            "DOMContentLoaded",
            (event) => {
                const selector = `#${market}Modal`;
                const modalElement = document.querySelector(selector);

                if (!modalElement) {
                    return;
                }

                const mode = modalElement.dataset.autoOpen;
                const fade = modalElement.classList.contains("fade");

                if (fade && mode === "instant") {
                    modalElement.classList.remove("fade");
                }

                modal[market] = new Modal(modalElement, {});

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
    });
</script>

<!-- Form -->
<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-5 col-md-8">
            <form class="bg-white rounded-5 shadow-5-strong p-5">
                <p class="fs-5 text text-dark mt-4">
                    Name one of your main skills
                </p>
                <p
                    id="skill_is_required"
                    class="text-danger m-0"
                    style="display:none;"
                >
                    Required
                </p>

                <div class="form-outline">
                    <input
                        type="text"
                        id="form12"
                        class="form-control"
                        style="border: 1px solid #ddd;"
                        placeholder=""
                        bind:value={skill}
                    />
                </div>

                <p class="fs-5 text text-dark mt-4">
                    How good are you at that?
                </p>
                <div class="row">
                    <div class="col-md-6">
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
                    </div>
                    <div class="col-md-6">
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
                    </div>
                </div>

                <p class="fs-5 text text-dark mt-4">What to you want to see?</p>
                <!-- Default radio -->
                <div class="form-check">
                    <input
                        class="form-check-input me-0"
                        type="radio"
                        name="market"
                        bind:group={market}
                        id="aflexRadioDefault13"
                        value="people"
                        checked
                    />
                    <label class="form-check-label" for="aflexRadioDefault13">
                        Related skills. I want to complete my profile.
                    </label>
                </div>

                <!-- Default checked radio -->
                <div class="form-check">
                    <input
                        class="form-check-input me-0"
                        type="radio"
                        name="market"
                        bind:group={market}
                        id="aflexRadioDefault23"
                        value="jobs"
                    />
                    <label
                        class="form-check-label mr-0"
                        for="aflexRadioDefault23"
                    >
                        Skills that I could develop to get more job offers.
                    </label>
                </div>

                <button
                    id="btn_explore"
                    type="button"
                    class="btn btn-primary btn-block mt-4"
                    on:click={submitForm}
                >
                    Explore
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Jobs Modal -->
<div
    class="modal fade"
    id="jobsModal"
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
            <div id="modal-body-jobs" class="modal-body">
                <!-- <p>Brief description here</p> -->
                <div id="modal-tags-jobs">
                    <span class="skill-tag" style="display: none;">
                        Placeholder
                    </span>
                </div>
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

<!-- People Modal -->
<div
    class="modal fade"
    id="peopleModal"
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
            <div id="modal-body-people" class="modal-body">
                <!-- <p>Brief description here</p> -->
                <div id="modal-tags-people">
                    <span class="skill-tag" style="display: none;">
                        Placeholder
                    </span>
                </div>
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
