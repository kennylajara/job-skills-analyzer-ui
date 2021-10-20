<script context="module">
    /**
     *
     * TODO: Don't rush... use environment variable
     *
     */
    // const API_URL = "http://localhost:3000/";
    const API_URL = "https://api.skills.kennylajara.com/";
</script>

<script>
    import { Modal } from "mdb-ui-kit";

    let sample = 1000;
    var skill = "";
    var proficiency = "master";
    var market = "people";

    let result = null;
    let username = "";
    var userskills = [];

    var modal = {};

    function getRandomColor() {
        var letters = "9ABCD".split("");
        var color = "#";
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * letters.length)];
        }
        return color;
    }

    /**
     * Print Related Skills
     */
    function printRelatedSkills(market, percentils) {
        document
            .getElementsByClassName("modal-desc-proficiency")
            .forEach((ele) => {
                ele.innerHTML = proficiency;
            });
        document.getElementsByClassName("modal-desc-skill").forEach((ele) => {
            ele.innerHTML = skill;
        });

        let iDiv = document.getElementById(`modal-tags-${market}`);
        iDiv.innerHTML = "";

        // Required vars to limit the number of low priority skills
        let skills_counter = 0;

        for (const key in percentils) {
            let innerDiv = document.createElement("span");
            skills_counter++;

            if (skills_counter > 40) {
                break;
            }

            if (!userskills.includes(key)) {
                // Print the tag
                innerDiv.style.color = "#222";
                innerDiv.style.backgroundColor = getRandomColor();
                innerDiv.style.margin = "5px";
                innerDiv.style.padding = "5px";
                innerDiv.style.borderRadius = "5px";
                innerDiv.style.display = "inline-block";
                innerDiv.innerHTML = `<strong>${key}</strong>`;

                iDiv.appendChild(innerDiv);
            }
        }
    }

    /**
     * Sumbit form
     */
    async function submitForm() {
        if (skill) {
            username = username.trim();

            if (username != "") {
                const res_user_skills = await fetch(
                    `${API_URL}people/${username}/skills`,
                    {
                        method: "GET",
                    }
                );

                const json_user_skills = await res_user_skills.json();
                userskills = JSON.parse(JSON.stringify(json_user_skills));
            } else {
                userskills = [];
            }

            if (!Array.isArray(userskills) && username != "") {
                modal["error"].show();
            } else {
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
    }

    /**
     * Modal window
     */
    ["jobs", "people", "error"].forEach((market) => {
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
    <h1>Skills</h1>
    <h2>A simple yet powerful job skills analyzer</h2>
    <div class="row justify-content-center my-2">
        <div class="col-xl-5 col-md-8">
            <form
                class="bg-white rounded-5 shadow-5-strong p-5"
                on:submit|preventDefault
            >
                <p class="fs-5 text text-dark mt-0 mb-2">
                    Name one of your skills or current/desired role:
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

                <p class="fs-5 text text-dark mt-4 mb-2">
                    How good are you at it?
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

                <p class="fs-5 text text-dark mt-4 mb-2">
                    What do you want to see?
                </p>
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
                        Complementary skills.
                        <span class="moreinfo">
                            - Useful to complete your <a
                                href="https://torre.co/genome"
                                target="_blank">Genome</a
                            >.
                        </span>
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
                        Related skills in demand.
                        <span class="moreinfo">
                            - Increase your chances to <a
                                href="https://torre.co/for-candidates"
                                target="_blank">get hired</a
                            >.
                        </span>
                    </label>
                </div>

                <p class="fs-5 text text-dark mt-4 mb-2">
                    Your username at Torre
                </p>
                <div class="form-outline">
                    <input
                        type="text"
                        id="form-username"
                        class="form-control"
                        style="border: 1px solid #ddd;"
                        placeholder=""
                        bind:value={username}
                    />
                </div>
                <span class="moreinfo mt-0">
                    If provided, we'll filter out the skills in your profile.
                </span>

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
    <p class="slogan">
        Based on the actual job market. Powered by <a
            href="https://torre.co"
            target="_blank"
        >
            Torre.co
        </a>
    </p>
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
                <h5 class="modal-title" id="exampleModalLabel">
                    Related skills in demand
                </h5>
                <button
                    type="button"
                    class="btn-close"
                    data-mdb-dismiss="modal"
                    aria-label="Close"
                />
            </div>
            <div id="modal-body-jobs" class="modal-body">
                <p class="fw-400">
                    Below is a list of the skills most appreciated by the job
                    market and related to the indicated role or skill (<span
                        class="modal-desc-skill fw-bold"
                    />). The selected proficiency level (<span
                        class="modal-desc-proficiency fw-bold"
                    />) is considered as well:
                </p>
                <p class="fw-400">
                    A maximum of 40 skills are presented ordered by relevance.
                </p>
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
                <h5 class="modal-title" id="exampleModalLabel">
                    Complementary Skills
                </h5>
                <button
                    type="button"
                    class="btn-close"
                    data-mdb-dismiss="modal"
                    aria-label="Close"
                />
            </div>
            <div id="modal-body-people" class="modal-body">
                <p class="fw-400">
                    The following is a list of complementary skills to the
                    indicated role or skill, according to the selected
                    proficiency level. In this case:
                    <span class="modal-desc-skill fw-bold" /> -
                    <span class="modal-desc-proficiency fw-bold" />.
                </p>
                <p class="fw-400">
                    A maximum of 40 skills are presented ordered by relevance.
                </p>
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

<!-- Error Modal -->
<div
    class="modal fade"
    id="errorModal"
    tabindex="-1"
    aria-labelledby="exampleModalLabel"
    aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-scrollable ">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">
                    Complementary Skills
                </h5>
                <button
                    type="button"
                    class="btn-close"
                    data-mdb-dismiss="modal"
                    aria-label="Close"
                />
            </div>
            <div id="modal-body-error" class="modal-body">
                The requested username doesn't exists.
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

    h1,
    h2,
    .slogan {
        text-align: center;
        color: white;
    }

    h1 {
        font-weight: bold;
    }

    h2 {
        font-size: large;
    }

    .slogan {
        font-size: small;
    }

    .slogan a {
        color: white;
        font-weight: bold;
    }
    .moreinfo {
        color: #777;
        font-size: small;
    }
</style>
