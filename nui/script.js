window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === "openUI") {
        $("#app").fadeIn(300).css("display", "flex");
        $("#ui-title-text").text(data.lang.ui_title);
        $("#ui-earned-label").text(data.lang.ui_earned);
        $("#ui-finished-label").text(data.lang.ui_finished);
        $("#ui-rank-label").html(`<i class="fa-solid fa-award"></i> ${data.lang.ui_rank}: <span id="rank-name">...</span>`);
        $("#ui-level-label").text(data.lang.ui_level);
        $(".logout-btn").html(`<i class="fa-solid fa-power-off"></i> ${data.lang.ui_exit}`);

        $("#p-name").html(`<i class="fa-solid fa-user-gear"></i> ${data.playerName}`);
        $("#lvl").text(data.stats.level);
        
        let currentRank = data.lang.rank_1;
        if (data.stats.level >= 10) currentRank = data.lang.rank_3;
        else if (data.stats.level >= 5) currentRank = data.lang.rank_2;
        $("#rank-name").text(currentRank);
        
        $("#total-earned").text("$" + (data.stats.total_money || 0).toLocaleString());
        $("#total-deliveries").text(data.stats.total_deliveries || 0);
        
        let progress = (data.stats.xp / (data.stats.level * 1500)) * 100;
        $("#xp-fill").css("width", progress + "%");
        
        let html = "";
        data.jobs.forEach((job, i) => {
            const isLocked = data.stats.level < job.minLevel;
            html += `
                <div class="job-card" style="${isLocked ? 'opacity: 0.6;' : ''}">
                    <div class="job-details">
                        <h3>${job.label} ${isLocked ? '<i class="fa-solid fa-lock" style="color:#ff9d00"></i>' : ''}</h3>
                        <p>${data.lang.ui_level} ${job.minLevel}</p>
                    </div>
                    <button class="select-btn" ${isLocked ? 'disabled' : `onclick="selectJob(${i})"`}>
                        ${isLocked ? data.lang.ui_locked : data.lang.ui_accept}
                    </button>
                </div>`;
        });
        $("#job-list").html(html);

    } else if (data.type === "notify") {
        const id = "notif_" + Math.random().toString(36).substr(2, 9);
        $("#notify-container").append(`<div id="${id}" class="notify-card ${data.ntype}">${data.message}</div>`);
        
        setTimeout(() => {
            $(`#${id}`).css("animation", "fadeOut 0.5s forwards");
            setTimeout(() => { $(`#${id}`).remove(); }, 500);
        }, 5000);
    }
});

function selectJob(i) {
    $.post(`https://${GetParentResourceName()}/selectJob`, JSON.stringify({index: i}));
    closeUI();
}

function closeUI() {
    $("#app").fadeOut(200);
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
}

$(document).keyup(function(e) {
    if (e.key === "Escape") closeUI();
});